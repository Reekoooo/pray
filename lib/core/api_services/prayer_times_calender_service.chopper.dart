// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_times_calender_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$CalenderService extends CalenderService {
  _$CalenderService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = CalenderService;

  @override
  Future<Response> getCalender(
      {double latitude,
      double longitude,
      int month,
      int year,
      bool annual,
      int method,
      String tune,
      int school,
      int midNightMode,
      String timezonestring,
      int latitudeAdjustmentMethod,
      int adjustment}) {
    final $url = '/v1/calendar';
    final $params = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'month': month,
      'year': year,
      'annual': annual,
      'method': method,
      'tune': tune,
      'school': school,
      'midNightMode': midNightMode,
      'timezonestring': timezonestring,
      'latitudeAdjustmentMethod': latitudeAdjustmentMethod,
      'adjustment': adjustment
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}

class _$CalenderByCityService extends CalenderByCityService {
  _$CalenderByCityService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = CalenderByCityService;

  @override
  Future<Response> getCalender(
      {String city,
      String country,
      String state,
      num month,
      num year,
      bool annual,
      num method,
      String tune,
      num school,
      num midnightMode,
      num latitudeAdjustmentMethod,
      num adjustment}) {
    final $url = '/v1/calendarByCity';
    final $params = <String, dynamic>{
      'city': city,
      'country': country,
      'state': state,
      'month': month,
      'year': year,
      'annual': annual,
      'method': method,
      'tune': tune,
      'school': school,
      'midnightMode': midnightMode,
      'latitudeAdjustmentMethod': latitudeAdjustmentMethod,
      'adjustment': adjustment
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}
