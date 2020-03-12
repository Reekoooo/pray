import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pray/core/exeptions.dart';
import 'package:pray/core/failures.dart';
import 'package:pray/features/data/data_source/local_data_source.dart';
import 'package:pray/features/data/data_source/location_data_source.dart';
import 'package:pray/features/data/data_source/nonifications_data_source.dart';
import 'package:pray/features/data/data_source/remote_data_source.dart';
import 'package:pray/features/data/model/location_model.dart';
import 'package:pray/features/data/model/models.dart';
import 'package:pray/features/data/repository/calender_month_repository_impl.dart';
import 'package:pray/features/domain/entity/azan_alarm.dart';
import 'package:pray/features/domain/entity/location_entity.dart';
import 'package:pray/features/domain/repository/calender_month_reepository.dart';

import '../../../core/jsonutil.dart';

class LocalDataSourceMock extends Mock implements LocalDataSource {}

class RemoteDataSourceMock extends Mock implements RemoteDataSource {}

class LocationDataSourceMock extends Mock implements LocationDataSource {}

class NotificationDataSourceMock extends Mock implements NotificationDataSource{}

void main() {
  LocalDataSource local;
  RemoteDataSource remote;
  LocationDataSource location;
  NotificationDataSource notifications;
  CalenderMonthRepository repositoryImpl;
  setUp(() {
    local = LocalDataSourceMock();
    remote = RemoteDataSourceMock();
    notifications = NotificationDataSourceMock();
    location = LocationDataSourceMock();
    repositoryImpl =
        CalenderMonthRepositoryImpl(local: local, remote: remote,location: location,notificationsDataSource: notifications);
  });

  group('month calender', () {
//    setUp(() {
//      local = LocalDataSourceMock();
//      remote = RemoteDataSourceMock();
//      repositoryImpl =
//          CalenderMonthRepositoryImpl(local: local, remote: remote,location: location);
//    });

    test('never call remote data source if local data is available', () async {
      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));
      when(local.getCalenderMonthByCity(
          city: anyNamed('city'),
          country: anyNamed('country'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenAnswer((_) => Future.value(calender));

      final actual = await repositoryImpl.getMonthCalender(
        city: 'Alexandria',
        country: 'Egypt',
        method: 0,
        date: DateTime(2020, 2, 16, 12, 30),
      );

      expect(actual, Right(calender));
      verifyZeroInteractions(remote);
    });

    test('get cashFailure when local cash exception', () async {
      // final testJson = await getJsonFromFile('calendermonth.json');
      // final calender = CalenderMonthModel.fromJson(json.decode(testJson));
      when(local.getCalenderMonthByCity(
          city: anyNamed('city'),
          country: anyNamed('country'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenThrow(CashException());

      final actual = await repositoryImpl.getMonthCalender(
          city: 'Alexandria',
          country: 'Egypt',
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30));

      expect(actual, Left(CashFailure()));
      // verify(remote.getCalenderMonth(
      //   city: 'Alexandria',country: 'Egypt',method: 0,date: DateTime(2020, 2, 16, 12,30),
      //   ));
    });

    test('call remote when local cash empty', () async {
      final testJson = await getJsonFromFile('calendermonth.json');
      final remoteCalender = CalenderMonthModel.fromJson(json.decode(testJson));
      final calender = CalenderMonthModel(code: 200, data: [], status: 'empty');
      when(local.getCalenderMonthByCity(
          city: anyNamed('city'),
          country: anyNamed('country'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenAnswer((_) => Future.value(calender));
      when(
        remote.getCalenderMonthByCity(
            city: anyNamed('city'),
            country: anyNamed('country'),
            method: anyNamed('method'),
            date: anyNamed('date')),
      ).thenAnswer((_) => Future.value(remoteCalender));

      await repositoryImpl.getMonthCalender(
          city: 'Alexandria',
          country: 'Egypt',
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30));

      verify(remote.getCalenderMonthByCity(
        city: 'Alexandria',
        country: 'Egypt',
        method: 0,
        date: DateTime(2020, 2, 16, 12, 30),
      ));
    });

    test('return Server failure  when local cash empty and server exception',
            () async {
          // final testJson = await getJsonFromFile('calendermonth.json');
          final calender = CalenderMonthModel(
              code: 200, data: [], status: 'empty');
          when(local.getCalenderMonthByCity(
              city: anyNamed('city'),
              country: anyNamed('country'),
              method: anyNamed('method'),
              date: anyNamed('date')))
              .thenAnswer((_) => Future.value(calender));

          when(remote.getCalenderMonthByCity(
              city: anyNamed('city'),
              country: anyNamed('country'),
              method: anyNamed('method'),
              date: anyNamed('date')))
              .thenThrow(ServerException());

          final actual = await repositoryImpl.getMonthCalender(
              city: 'Alexandria',
              country: 'Egypt',
              method: 0,
              date: DateTime(2020, 2, 16, 12, 30));

          expect(actual, Left(ServerFailure()));
        });
  });

  group('day calender', () {
//    setUp(() {
//      local = LocalDataSourceMock();
//      remote = RemoteDataSourceMock();
//      repositoryImpl =
//          CalenderMonthRepositoryImpl(local: local, remote: remote,location: location);
//    });
    test('should return single data', () async {
      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));
      when(local.getCalenderMonthByCity(
          city: anyNamed('city'),
          country: anyNamed('country'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenAnswer((_) => Future.value(calender));

      final actual = await repositoryImpl.getDayCalender(
        city: 'Alexandria',
        country: 'Egypt',
        method: 0,
        date: DateTime(2020, 2, 16, 12, 30),
      );

      expect(actual, Right(calender.data[15]));
    });
    test('should return Cash failure when local exception ', () async {
      // final testJson = await getJsonFromFile('calendermonth.json');
      // final calender = CalenderMonthModel.fromJson(json.decode(testJson));
      when(local.getCalenderMonthByCity(
          city: anyNamed('city'),
          country: anyNamed('country'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenThrow(CashException());

      final actual = await repositoryImpl.getDayCalender(
        city: 'Alexandria',
        country: 'Egypt',
        method: 0,
        date: DateTime(2020, 2, 16, 12, 30),
      );

      expect(actual, Left(CashFailure()));
    });
  });

  group('location', () {
//    setUp(() {
//      location = LocationDataSourceMock();
//      local = LocalDataSourceMock();
//      remote = RemoteDataSourceMock();
//      repositoryImpl =
//          CalenderMonthRepositoryImpl(local: local, remote: remote,location: location);
//    });

    test('return Calender month for location', () async {
      //device location mock response
      final deviceLocation = DeviceLocation(
        latitude: 1.0,
        longitude: 1.1,
      );
      final devicePlaceMark = DevicePlaceMark(country: 'Egypt',city: 'Alexandria');
      when(location.getCurrentLocation()).thenAnswer((_) =>
          Future.value(deviceLocation));
      when(location.getPlaceMarkFromPosition(location: anyNamed("location")))
          .thenAnswer((_)=>Future.value(devicePlaceMark));

      //local data source empty response mock to force remote call
      final calender = CalenderMonthModel(code: 200, data: [], status: 'empty');
      when(local.getCalenderMonthByCity(
          city: anyNamed('city'),
          country: anyNamed('country'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenAnswer((_) => Future.value(calender));

      //remote mock response with actual data model
      final testJson = await getJsonFromFile('calendermonth.json');
      final remoteCalender = CalenderMonthModel.fromJson(json.decode(testJson));
      when(
        remote.getCalenderMonthByLocation(
            longitude: anyNamed('longitude'),
            latitude: anyNamed('latitude'),
            method: anyNamed('method'),
            date: anyNamed('date')),
      ).thenAnswer((_) => Future.value(remoteCalender));



      final actual = await repositoryImpl.getMonthCalenderByLocation(
        latitude: 1.0,
        longitude: 1.1,
        method: 5,
        date: DateTime(2020, 2, 16, 12, 30),);

      //verify(location.getCurrentLocation());

      expect(actual, Right(remoteCalender));
    });
    test('return Today for location',() async{
      //device location mock response
      final deviceLocation = DeviceLocation(
        latitude: 1.0,
        longitude: 1.1,
      );
      final devicePlaceMark = DevicePlaceMark(country: 'Egypt',city: 'Alexandria');
      when(location.getCurrentLocation()).thenAnswer((_) =>
          Future.value(deviceLocation));
      when(location.getPlaceMarkFromPosition(location: anyNamed("location")))
          .thenAnswer((_)=>Future.value(devicePlaceMark));
      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));
//      final deviceLocation = DeviceLocation(
//        latitude: 1.0,
//        longitude: 1.1,
//      );
      when(local.getCalenderMonthByCity(
          city: anyNamed('city'),
          country: anyNamed('country'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenAnswer((_) => Future.value(calender));
      when(location.getCurrentLocation()).thenAnswer((_) =>
          Future.value(deviceLocation));

      final actual = await repositoryImpl.getDayCalenderByLocation(
        longitude:1.1,
        latitude: 1.0,
        method: 0,
        date: DateTime(2020, 2, 16, 12, 30),
      );

      expect(actual, Right(calender.data[15]));

    });

  });

  group('notifications', (){

    test('should return true when success', () async{
      final azanNotifications = [AzanAlarm(azanDateTime: DateTime(2020, 2, 16, 12, 30))];
      when(notifications.setNotifications(notifications: anyNamed('notifications'))).thenAnswer((_)=>Future.value(true));
      final actual = await repositoryImpl.setAzanNotifications(notifications: azanNotifications);
      expect(actual,Right(true));
    });

    test('should return notifications failure when notifications exception',() async{
      final azanNotifications = [AzanAlarm(azanDateTime: DateTime(2020, 2, 16, 12, 30))];
      when(notifications.setNotifications(notifications: anyNamed('notifications'))).thenThrow(NotificationsException());
      final actual = await repositoryImpl.setAzanNotifications(notifications: azanNotifications);
      expect(actual, Left(NotificationFailure()));
    });
  });
}
