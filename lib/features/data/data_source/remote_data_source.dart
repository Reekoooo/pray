import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pray/core/api_services/prayer_times_calender_service.dart';
import 'package:pray/core/exeptions.dart';
import 'package:pray/features/data/model/models.dart';
import 'package:pray/features/domain/entity/entity.dart';

abstract class RemoteDataSource {
  Future<CalenderMonth> getCalenderMonthByCity(
      {@required String city,
      @required String country,
      @required int method,
      @required DateTime date});

  Future<CalenderMonth> getCalenderMonthByLocation(
      {@required double latitude,
      @required double longitude,
      @required int method,
      @required DateTime date});
}

class RemoteDataSourceImpl extends RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({@required this.client});

  @override
  Future<CalenderMonth> getCalenderMonthByCity(
      {@required String city,
      @required String country,
      @required int method,
      @required DateTime date}) async {
//    final url = 'http://api.aladhan.com/v1/calendarByCity?city=$city&country=$country&method=${method.toString()}&month=${date.month.toString()}&year=${date.year.toString()}&timezonestring=UTC';
//    final response = await client.get(url);
    final chopper = ChopperClient(
      baseUrl: "http://api.aladhan.com",
      client: client,
      services: [
        // the generated service
        CalenderByCityService.create()
      ],
      converter: JsonConverter(),
    );

    final calenderByCityService = CalenderByCityService.create(chopper);
    final response = await calenderByCityService.getCalender(
      city: city,
      // 31.1039, 29.7698
      country: country,
      // 29.7698,
      method: method,
      month: date.month,
      year: date.year,
    );

    if(response.isSuccessful){
      final rawJson = response.body;
      return CalenderMonthModel.fromJson(rawJson);
    }else{
      throw ServerException();
    }


  }

  @override
  Future<CalenderMonth> getCalenderMonthByLocation(
      {double latitude, double longitude, int method, DateTime date}) async {
    final chopper = ChopperClient(
      baseUrl: "http://api.aladhan.com",
      client: client,
      services: [
        // the generated service
        CalenderService.create()
      ],
      converter: JsonConverter(),
    );

    final calenderService = CalenderService.create(chopper);

    final response = await calenderService.getCalender(
      latitude: latitude,
      //31.1039, //31.1039, 29.7698
      longitude: longitude,
      //29.7698,
      month: date.month,
      year: date.year,
      method: method,
      timezonestring: (r'UTC'),
    );

    if(response.isSuccessful){
      final rawJson = response.body;
      return CalenderMonthModel.fromJson(rawJson);
    }else{
      throw ServerException();
    }
  }
}
