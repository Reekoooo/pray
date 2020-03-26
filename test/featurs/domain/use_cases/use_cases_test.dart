import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pray/core/failures.dart';
import 'package:pray/features/data/model/models.dart';
import 'package:pray/features/domain/entity/azan_alarm.dart';
import 'package:pray/features/domain/repository/calender_month_reepository.dart';
import 'package:pray/features/domain/use_cases/use_cases.dart';

import '../../../core/jsonutil.dart';

class CalenderMonthRepositoryMock extends Mock
    implements CalenderMonthRepository {}

void main() {
  CalenderMonthRepositoryMock repositoryMock;
//  GetCalenderMonthUseCase usecase;
//  GetCalenderToDayUseCase todayUseCase;
//  SetAzanNotificationsUseCase azanNotificationsUseCase;
//  GetCalenderMonthByLocation locationUseCase;
//  GetCalenderTodayByLocationUseCase todayLocationUseCase;

  setUp(() {
    repositoryMock = CalenderMonthRepositoryMock();
  });

  group('Month data by city', () {
    setUp(() {
    //  usecase = GetCalenderMonthUseCase(repository: repositoryMock);
    });
    test('should return list of Month data by city and country', () async {
      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));

      when(repositoryMock.getMonthCalenderByCity(
          city: anyNamed('city'),
          country: anyNamed('country'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenAnswer((_) => Future.value(Right(calender)));

//      final actual = await usecase.getMonthCalender(
//          city: 'Alexandria',
//          country: 'Egypt',
//          method: 0,
//          date: DateTime(2020, 2, 16, 12, 30));

      verify(repositoryMock.getMonthCalenderByCity(
          city: 'Alexandria',
          country: 'Egypt',
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30)));

//      expect(actual, Right(calender));
    });

    test('should return failure when repository failure provided', () async {
      when(repositoryMock.getMonthCalenderByCity(
          city: anyNamed('city'),
          country: anyNamed('country'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenAnswer((_) => Future.value(Left(ServerFailure())));

     // final actual = await usecase.getMonthCalender(
//          city: 'Alexandria',
//          country: 'Egypt',
//          method: 0,
//          date: DateTime(2020, 2, 16, 12, 30));

      verify(repositoryMock.getMonthCalenderByCity(
          city: 'Alexandria',
          country: 'Egypt',
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30)));

//      expect(actual, Left(ServerFailure()));
    });
  });

  group('today data by city', () {
    setUp(() {
//      todayUseCase = GetCalenderToDayUseCase(repository: repositoryMock);
    });
    test('should return today calender ', () async {
      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));
      final data = calender.data[0];
//      when(repositoryMock.getDayCalender(
//          city: anyNamed('city'),
//          country: anyNamed('country'),
//          method: anyNamed('method'),
//          date: anyNamed('date')))
//          .thenAnswer((_) => Future.value(Right(data)));

//      final actual = await todayUseCase.getTodayCalender(
//        city: 'Alexandria',
//        country: 'Egypt',
//        method: 0,
//      );

//      expect(actual, Right(data));
    });

    test('should return failure when repository failure provided', () async {
//      when(repositoryMock.getDayCalender(
//          city: anyNamed('city'),
//          country: anyNamed('country'),
//          method: anyNamed('method'),
//          date: anyNamed('date')))
//          .thenAnswer((_) => Future.value(Left(ServerFailure())));

//      final actual = await todayUseCase.getTodayCalender(
//        city: 'Alexandria',
//        country: 'Egypt',
//        method: 0,
//      );

//      verify(repositoryMock.getDayCalender(
//          city: 'Alexandria',
//          country: 'Egypt',
//          method: 0,
//          date: anyNamed('date')));

//      expect(actual, Left(ServerFailure()));
    });
  });

  group('month data by location', () {
    setUp(() {
//      locationUseCase = GetCalenderMonthByLocation(repository: repositoryMock);
    });

    test('should return month data by city and country', () async {
      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));

      when(repositoryMock.getMonthCalenderByLocation(
          longitude: anyNamed('longitude'),
          latitude: anyNamed('latitude'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenAnswer((_) => Future.value(Right(calender)));

//      final actual = await locationUseCase.getMonthCalenderByLocation(
//        longitude: 1.0,
//        latitude: 1.1,
//        method: 0,
//        date: DateTime(2020, 2, 16, 12, 30),);
//      expect(actual, Right(calender));

      verify(repositoryMock.getMonthCalenderByLocation(
          latitude: 1.1,
          longitude: 1.0,
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30)));
    });

    test('should return failure when repository failure provided', () async {
      when(repositoryMock.getMonthCalenderByLocation(
          longitude: anyNamed('longitude'),
          latitude: anyNamed('latitude'),
          method: anyNamed('method'),
          date: anyNamed('date')))
          .thenAnswer((_) => Future.value(Left(ServerFailure())));

//      final actual = await locationUseCase.getMonthCalenderByLocation(
//          latitude: 1.0,
//          longitude: 1.1,
//          method: 0,
//          date: DateTime(2020, 2, 16, 12, 30));
//
//      expect(actual, Left(ServerFailure()));

      verify(repositoryMock.getMonthCalenderByLocation(
          latitude: 1.0,
          longitude: 1.1,
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30)));
    });
  });

  group('today data by location', () {
    setUp(() {
//      todayLocationUseCase =
//          GetCalenderTodayByLocationUseCase(repository: repositoryMock);
    });

    test('shouldreturn today calender when location provided', () async {
      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));
      final data = calender.data[0];
//      when(repositoryMock.getDayCalenderByLocation(
//          longitude: anyNamed('longitude'),
//          latitude: anyNamed('latitude'),
//          method: anyNamed('method'),
//          date: anyNamed('date')))
//          .thenAnswer((_) => Future.value(Right(data)));

//      final actual = await todayLocationUseCase.getTodayCalenderByLocation(
//        longitude: 1.0,
//        latitude: 1.1,
//        method: 0,
//      );

//      expect(actual, Right(data));
    });

    test('should return failure when repository failure provided', () async {
//      when(repositoryMock.getDayCalenderByLocation(
//          longitude: anyNamed('longitude'),
//          latitude: anyNamed('latitude'),
//          method: anyNamed('method'),
//          date: anyNamed('date')))
//          .thenAnswer((_) => Future.value(Left(ServerFailure())));

//      final actual = await todayLocationUseCase.getTodayCalenderByLocation(
//        method: 0,
//      );

//      expect(actual, Left(ServerFailure()));
    });
  });

  group('nonifications', () {
    setUp(() {
//      azanNotificationsUseCase =
//          SetAzanNotificationsUseCase(repository: repositoryMock);
    });

    test('should return true when alarm set', () async{
      final azanNotifications = [AzanAlarm(azanDateTime: DateTime(2020, 2, 16, 12, 30))];

      when(repositoryMock.setAzanNotifications(
          notifications: anyNamed('notifications'))).thenAnswer((_) =>
          Future.value(Right(true)));
//
//      final actual = await azanNotificationsUseCase.setNotifications(notifications: azanNotifications);
//      expect(actual, Right(true));
//      verify(repositoryMock.setAzanNotifications(notifications: azanNotifications));
    });
    test('should return notification failure when error', ()async{
      final azanNotifications = [AzanAlarm(azanDateTime: DateTime(2020, 2, 16, 12, 30))];
      when(repositoryMock.setAzanNotifications(
          notifications: anyNamed('notifications'))).thenAnswer((_)=>Future.value(Left(NotificationFailure())));

//      final actual = await azanNotificationsUseCase.setNotifications(notifications: azanNotifications);
//      expect(actual, Left(NotificationFailure()));


    });
  });
}
