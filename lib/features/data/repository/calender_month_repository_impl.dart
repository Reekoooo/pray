import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pray/core/exeptions.dart';
import 'package:pray/core/failures.dart';
import 'package:pray/features/data/data_source/local_data_source.dart';
import 'package:pray/features/data/data_source/location_data_source.dart';
import 'package:pray/features/data/data_source/nonifications_data_source.dart';
import 'package:pray/features/data/data_source/remote_data_source.dart';
import 'package:pray/features/data/model/models.dart';
import 'package:pray/features/domain/entity/azan_alarm.dart';
import 'package:pray/features/domain/entity/entity.dart';
import 'package:pray/features/domain/entity/location_entity.dart';
import 'package:pray/features/domain/entity/settings.dart';
import 'package:pray/features/domain/repository/calender_month_reepository.dart';

import 'package:isolate/isolate_runner.dart';

class CalenderMonthRepositoryImpl extends CalenderMonthRepository {
  CalenderMonthRepositoryImpl({
    @required this.local,
    @required this.remote,
    @required this.location,
    @required this.notificationsDataSource,
  });

  final LocalDataSource local;
  final RemoteDataSource remote;
  final LocationDataSource location;
  final NotificationDataSource notificationsDataSource;

  @override
  Future<Either<Failure, CalenderMonth>> getMonthCalenderByCity(
      {@required String city,
      @required String country,
      @required int method,
      @required DateTime date}) async {
    Either<Failure, CalenderMonth> data;

    try {
      final calender = await local.getCalenderMonthByCity(
          city: city, country: country, method: method, date: date);

      if (calender.status != 'empty') {
        data = Right(calender);
      } else {
        //print("city is $city country is $country");
        try {
          final calenderByCity = await remote.getCalenderMonthByCity(
            city: city,
            country: country,
            method: method,
            date: date,
          );

          final longitude = calenderByCity.data[0].meta.longitude;
          final latitude = calenderByCity.data[0].meta.latitude;

          final calenderByLocation = await remote.getCalenderMonthByLocation(
            latitude: latitude,
            longitude: longitude,
            method: method,
            date: date,
          );

          final key =
              '${country}_${city}_${method}_${date.month.toString()}_${date.year.toString()}';
          final jsonString =
              json.encode((calenderByLocation as CalenderMonthModel).toJson());

          await local.saveCalenderMonth(key: key, jsonString: jsonString);

          data = Right(calenderByLocation);
        } on ServerException {
          data = Left(ServerFailure());
          return data;
        }
      }
    } on CashException {
      data = Left(CashFailure());
      return data;
    }

    return data;
  }

  @override
  Future<Either<Failure, CalenderMonth>> getMonthCalenderByLocation(
      {double latitude,
      double longitude,
      @required int method,
      @required DateTime date}) async {
    final deviceLocation =
        DeviceLocation(longitude: longitude, latitude: latitude);

    final devicePlaceMark =
        await location.getPlaceMarkFromPosition(location: deviceLocation);

    try{

      final calender = await local.getCalenderMonthByCity(
        city: devicePlaceMark.city,
        country: devicePlaceMark.country,
        method: method,
        date: date,
      );

      if(calender.status =="empty"){
        try {
          final calender = await remote.getCalenderMonthByLocation(
              latitude: latitude, longitude: longitude, method: method, date: date);

          final key =
              '${devicePlaceMark.country}_${devicePlaceMark.city}_${method}_${date.month.toString()}_${date.year.toString()}';
          final jsonString =
          json.encode((calender as CalenderMonthModel).toJson());

          await local.saveCalenderMonth(key: key, jsonString: jsonString);
          return Right(calender);
        } on ServerException {
          return Left(ServerFailure());
        }
      }else{
        return Right(calender);
      }

    }on CashException{
      return(Left(CashFailure()));
    }

  }

  @override
  Future<Either<Failure, bool>> setAzanNotifications(
      {List<AzanAlarm> notifications}) async {
    try {
      final notificationSuccess = await notificationsDataSource
          .setNotifications(notifications: notifications);
      return Right(notificationSuccess);
    } on NotificationsException {
      return Left(NotificationFailure());
    }
  }

  @override
  Future<Either<Failure, DeviceLocation>> getDeviceLocation() async{
    try{
      final deviceLocation = await location.getCurrentLocation();
      return Right(deviceLocation);
    }on LocationException catch(e) {
      return Left(LocationFailure(id: e.id));
    }
  }

  @override
  Future<Either<Failure, DevicePlaceMark>> getDevicePlaceMark() async{
    try{
      final devicePlaceMark = await location.getCurrentPlaceMark();
      return Right(devicePlaceMark);
    } on LocationException catch(e){
      return Left(LocationFailure(id: e.id));
    }

  }

  @override
  Future<Either<Failure, Settings>> loadSettings() async{
    try{
      final settings = await local.loadSettings();
      return Right(settings);
    }on CashException {
      return Left(CashFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings({Settings settings}) async{

    try{
      final answer = await local.saveSettings(settingsModel: settings);
      return Right(answer);
    }on CashException{
      return Left(CashFailure());
    }
    return null;
  }
}
