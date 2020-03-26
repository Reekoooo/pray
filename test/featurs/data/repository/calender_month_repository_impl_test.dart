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
import 'package:pray/features/data/model/models.dart';
import 'package:pray/features/data/model/settings_model.dart';
import 'package:pray/features/data/repository/calender_month_repository_impl.dart';
import 'package:pray/features/domain/entity/azan_alarm.dart';
import 'package:pray/features/domain/entity/location_entity.dart';
import 'package:pray/features/domain/repository/calender_month_reepository.dart';

import '../../../core/jsonutil.dart';

class LocalDataSourceMock extends Mock implements LocalDataSource {}

class RemoteDataSourceMock extends Mock implements RemoteDataSource {}

class LocationDataSourceMock extends Mock implements LocationDataSource {}

class NotificationDataSourceMock extends Mock
    implements NotificationDataSource {}

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
    repositoryImpl = CalenderMonthRepositoryImpl(
        local: local,
        remote: remote,
        location: location,
        notificationsDataSource: notifications);
  });

  group('month calender by city', () {

    test('never call remote data source if local data is available', () async {
      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));
      when(local.getCalenderMonthByCity(
              city: anyNamed('city'),
              country: anyNamed('country'),
              method: anyNamed('method'),
              date: anyNamed('date')))
          .thenAnswer((_) => Future.value(calender));

      final actual = await repositoryImpl.getMonthCalenderByCity(
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

      final actual = await repositoryImpl.getMonthCalenderByCity(
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

      when(
        remote.getCalenderMonthByLocation(
            longitude: anyNamed('longitude'),
            latitude: anyNamed('latitude'),
            method: anyNamed('method'),
            date: anyNamed('date')),
      ).thenAnswer((_) => Future.value(remoteCalender));

      await repositoryImpl.getMonthCalenderByCity(
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

    test('save cash when remote is called', () async {
      final testJson = await getJsonFromFile('calendermonth.json');
      final remoteCalender = CalenderMonthModel.fromJson(json.decode(testJson));
      final calender = CalenderMonthModel(code: 200, data: [], status: 'empty');
      final key = 'Egypt_Alexandria_0_2_2020';
      final jsonString = testJson;
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

      when(
        remote.getCalenderMonthByLocation(
            longitude: anyNamed('longitude'),
            latitude: anyNamed('latitude'),
            method: anyNamed('method'),
            date: anyNamed('date')),
      ).thenAnswer((_) => Future.value(remoteCalender));

      await repositoryImpl.getMonthCalenderByCity(
          city: 'Alexandria',
          country: 'Egypt',
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30));

      verify(local.saveCalenderMonth(key: key, jsonString: jsonString));
    });

    test('return Server failure  when local cash empty and server exception',
        () async {
      // final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel(code: 200, data: [], status: 'empty');
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

      final actual = await repositoryImpl.getMonthCalenderByCity(
          city: 'Alexandria',
          country: 'Egypt',
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30));

      expect(actual, Left(ServerFailure()));
    });
  });

  group('month calender by location', () {

    test('return Calender month for location when http success', () async {
//      device location mock response
      final deviceLocation = DeviceLocation(
        latitude: 1.0,
        longitude: 1.1,
      );
      final devicePlaceMark =
          DevicePlaceMark(country: 'Egypt', city: 'Alexandria');
//      when(location.getCurrentLocation()).thenAnswer((_) =>
//          Future.value(deviceLocation));
      when(location.getPlaceMarkFromPosition(location: anyNamed("location")))
          .thenAnswer((_) => Future.value(devicePlaceMark));

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
        date: DateTime(2020, 2, 16, 12, 30),
      );

      expect(actual, Right(remoteCalender));
    });

    test('should return server failure when http bad request', () async {
      final deviceLocation = DeviceLocation(
        latitude: 1.0,
        longitude: 1.1,
      );
      final devicePlaceMark =
          DevicePlaceMark(country: 'Egypt', city: 'Alexandria');
//      when(location.getCurrentLocation()).thenAnswer((_) =>
//          Future.value(deviceLocation));
      when(location.getPlaceMarkFromPosition(location: anyNamed("location")))
          .thenAnswer((_) => Future.value(devicePlaceMark));

      //local data source empty response mock to force remote call
      final calender = CalenderMonthModel(code: 200, data: [], status: 'empty');
      when(local.getCalenderMonthByCity(
              city: anyNamed('city'),
              country: anyNamed('country'),
              method: anyNamed('method'),
              date: anyNamed('date')))
          .thenAnswer((_) => Future.value(calender));

      when(
        remote.getCalenderMonthByLocation(
            longitude: anyNamed('longitude'),
            latitude: anyNamed('latitude'),
            method: anyNamed('method'),
            date: anyNamed('date')),
      ).thenThrow(ServerException());

      final actual = await repositoryImpl.getMonthCalenderByLocation(
        latitude: 1.0,
        longitude: 1.1,
        method: 5,
        date: DateTime(2020, 2, 16, 12, 30),
      );

      expect(actual, Left(ServerFailure()));
    });
  });

  group('notifications', () {

    test('should return true when success', () async {
      final azanNotifications = [
        AzanAlarm(azanDateTime: DateTime(2020, 2, 16, 12, 30))
      ];
      when(notifications.setNotifications(
              notifications: anyNamed('notifications')))
          .thenAnswer((_) => Future.value(true));
      final actual = await repositoryImpl.setAzanNotifications(
          notifications: azanNotifications);
      expect(actual, Right(true));
    });

    test('should return notifications failure when notifications exception',
        () async {
      final azanNotifications = [
        AzanAlarm(azanDateTime: DateTime(2020, 2, 16, 12, 30))
      ];
      when(notifications.setNotifications(
              notifications: anyNamed('notifications')))
          .thenThrow(NotificationsException());
      final actual = await repositoryImpl.setAzanNotifications(
          notifications: azanNotifications);
      expect(actual, Left(NotificationFailure()));
    });
  });

  group('location',() {
    test('should return current device location ',() async{
      final deviceLocation = DeviceLocation(latitude: 1.0,longitude: 1.1);

      when(location.getCurrentLocation()).thenAnswer((_)=>Future.value(deviceLocation));

      final actual = await repositoryImpl.getDeviceLocation();

      expect(actual,Right(deviceLocation));
    });

    test('should return Location failure when location exception ',() async{
      //final deviceLocation = DeviceLocation(latitude: 1.0,longitude: 1.1);

      when(location.getCurrentLocation()).thenThrow(LocationException(id: LocationFailure.denied));

      final actual = await repositoryImpl.getDeviceLocation();

      expect(actual,Left(LocationFailure(id: LocationFailure.denied)));
    });

    test('should return current place mark',() async{
      final devicePlaceMark = DevicePlaceMark(city: 'Alexandria',country: 'Egypt');
      when(location.getCurrentPlaceMark())
          .thenAnswer((_)=>Future.value(devicePlaceMark));

      final actual = await repositoryImpl.getDevicePlaceMark();

      expect(actual,Right(devicePlaceMark));
    });

    test('return location failure when location exception',() async{
      when(location.getCurrentPlaceMark()).thenThrow(LocationException(id: LocationFailure.denied));
      final actual = await repositoryImpl.getDevicePlaceMark();
      expect(actual,Left(LocationFailure(id: LocationFailure.denied)));
    });

  });

  group('settings', (){
    test('should return settings', () async{
      final settings = SettingsModel(city: 'Alexandria',country: 'Egypt');
      when(local.loadSettings()).thenAnswer((_)=>Future.value(settings));
      final actual = await repositoryImpl.loadSettings();
      expect(actual , Right(settings));
    });
    test('should return cash failure when cash exception', ()async{
      when(local.loadSettings()).thenThrow(CashException());
      final actual = await repositoryImpl.loadSettings();
      expect(actual , Left(CashFailure()));
    });

    test('should save settings',() async{
      final settings =  SettingsModel(city: 'Alexandria',country: 'Egypt');
      when(local.saveSettings(settingsModel: anyNamed('settingsModel')))
      .thenAnswer((_)=>Future.value(null));

      final actual = await repositoryImpl.saveSettings(settings: settings);
      expect(actual,Right(null));
      verify(local.saveSettings(settingsModel: settings));
    });

    test('should return cash failure when save fail with cash exception', () async{
      final settings =  SettingsModel(city: 'Alexandria',country: 'Egypt');
      when(local.saveSettings(settingsModel: anyNamed('settingsModel')))
          .thenThrow(CashException());
      final actual = await repositoryImpl.saveSettings(settings: settings);

      expect(actual,Left(CashFailure()));

    });
  });
}
