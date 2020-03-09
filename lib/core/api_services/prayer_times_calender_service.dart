import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

part 'prayer_times_calender_service.chopper.dart';

@ChopperApi(baseUrl: '/v1')
abstract class CalenderService extends ChopperService {
  static CalenderService create([ChopperClient client]) =>
      _$CalenderService(client);

  @Get(path: "/calendar")
  Future<Response> getCalender({
    @Query('latitude') @required double latitude,
    @Query('longitude') @required double longitude,
    @Query('month') @required int month,
    @Query('year') @required int year,
    @Query('annual') bool annual,
    @Query('method') @required int method,
    @Query('tune') String tune,
    @Query('school') int school,
    @Query('midNightMode') int midNightMode,
    @Query('timezonestring') String timezonestring,
    @Query('latitudeAdjustmentMethod') int latitudeAdjustmentMethod,
    @Query('adjustment') int adjustment,
  });
}

@ChopperApi(baseUrl: '/v1')
abstract class CalenderByCityService extends ChopperService {
  static CalenderByCityService create([ChopperClient client]) =>
      _$CalenderByCityService(client);

  @Get(path: '/calendarByCity')
  Future<Response> getCalender({
    @Query('city') @required String city,
    @Query('country') @required String country,
    @Query('state') String state,
    @Query('month') @required num month,
    @Query('year') @required num year,
    @Query('annual') bool annual ,
    @Query('method') @required num method,
    @Query('tune') String tune,
    @Query('school') num school,
    @Query('midnightMode') num midnightMode,
    @Query('latitudeAdjustmentMethod') num latitudeAdjustmentMethod,
    @Query('adjustment') num adjustment
  });
}
