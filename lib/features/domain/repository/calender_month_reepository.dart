import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pray/core/failures.dart';
import 'package:pray/features/domain/entity/azan_alarm.dart';
import 'package:pray/features/domain/entity/entity.dart';
import 'package:pray/features/domain/entity/location_entity.dart';
import 'package:pray/features/domain/entity/settings.dart';

abstract class CalenderMonthRepository {

  //http://api.aladhan.com/v1/calendarByCity?city=London&country=United%20Kingdom&method=2&month=04&year=2017

Future<Either<Failure,CalenderMonth>> getMonthCalenderByCity ({@required String city,@required String country,@required int method,@required DateTime date});
Future<Either<Failure,CalenderMonth>> getMonthCalenderByLocation({@required double latitude,@required double longitude,@required int method,@required DateTime date});
Future<Either<Failure,bool>> setAzanNotifications({@required List<AzanAlarm> notifications});
Future<Either<Failure,DeviceLocation>> getDeviceLocation();
Future<Either<Failure,DevicePlaceMark>> getDevicePlaceMark();
Future<Either<Failure,Settings>> loadSettings();
Future<Either<Failure,void>> saveSettings({@required Settings settings});
}