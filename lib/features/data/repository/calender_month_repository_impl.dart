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
import 'package:pray/features/domain/repository/calender_month_reepository.dart';

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
  Future<Either<Failure, Data>> getDayCalender(
      {@required String city,
      @required String country,
      @required int method,
      @required DateTime date}) async {
    final calender = await getMonthCalender(
        city: city, country: country, method: method, date: date);
    if (calender is Right) {
      final data =
          (((calender as Right).value) as CalenderMonth).data[date.day - 1];
      return Right(data);
    }
    return Left((calender as Left).value);
  }

  @override
  Future<Either<Failure, CalenderMonth>> getMonthCalender({
    @required String city,
    @required String country,
    @required int method,
    @required DateTime date}) async {
    Either<Failure, CalenderMonth> data;

    try {
      final calender = await local.getCalenderMonth(
          city: city, country: country, method: method, date: date);

      if (calender.status != 'empty') {
        data = Right(calender);
      } else {
        print("city is $city country is $country");
        try {
          final calender = await remote.getCalenderMonth(
              city: city, country: country, method: method, date: date);
          data = Right(calender);

          final key =
              '${country}_${city}_${method}_${date.month.toString()}_${date.year.toString()}';
          final jsonString =
              json.encode((calender as CalenderMonthModel).toJson());

          local.saveCalenderMonth(key: key, jsonString: jsonString);
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

    DeviceLocation currentDeviceLocation;

    if(latitude==null || longitude == null){
      currentDeviceLocation = await location.getCurrentLocation();
    }
    DeviceLocation deviceLocation = DeviceLocation(
      latitude: latitude ?? currentDeviceLocation.latitude,
      longitude: longitude ?? currentDeviceLocation.longitude,
    );
    final devicePlaceMark = await location.getPlaceMarkFromPosition(location: deviceLocation);


    Either<Failure, CalenderMonth> data;

    try {
      final calender = await local.getCalenderMonth(
          city: devicePlaceMark.city,
          country: devicePlaceMark.country,
          method: method,
          date: date);

      if (calender.status != "empty") {
        data = Right(calender);
      } else {
        try {
          final calender = await remote.getCalenderMonthByLocation(
              longitude: longitude ?? deviceLocation.longitude,
              latitude: latitude ?? deviceLocation.latitude,
              method: method,
              date: date);
          data = Right(calender);



          final devicePlaceMark = await location.getPlaceMarkFromPosition(location: deviceLocation );
          final country = devicePlaceMark.country;
          final city = devicePlaceMark.city;


          final key = '${country}_${city}_${method}_${date.month.toString()}_${date.year.toString()}';
          final jsonString = json.encode((calender as CalenderMonthModel).toJson());

          local.saveCalenderMonth(key: key,jsonString: jsonString);

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
  Future<Either<Failure, Data>> getDayCalenderByLocation(
      {double longitude,
      double latitude,
      @required int method,
      DateTime date}) async {
    final calender =
        await getMonthCalenderByLocation(method: method, date: date);
    if (calender is Right) {
      print('Date is $date');
      print(
          'calender is${(((calender as Right).value) as CalenderMonth).data}');
      final data =
          (((calender as Right).value) as CalenderMonth).data[date.day - 1];
      return Right(data);
    }
    return Left((calender as Left).value);
  }

  @override
  Future<Either<Failure, bool>> setAzanNotifications (
      {List<AzanAlarm> notifications}) async{
    try{
      final notificationSuccess = await notificationsDataSource.setNotifications(notifications: notifications);
      return Right(notificationSuccess);

    }on NotificationsException{
      return Left(NotificationFailure());
    }

  }

  @override
  Future<Either<Failure, CalenderMonth>> getMonthCalenderForCurrentLocation({int method, DateTime date}) async{
    var devicePlaceMark;
    try{
      devicePlaceMark = await location.getCurrentPlaceMark();
      final calender = await getMonthCalender(city: devicePlaceMark.city, country: devicePlaceMark.country, method: method, date: date??DateTime.now());
      return calender;
    }on LocationException{
      return Left(LocationFailure());
    }
  }
}
