import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pray/features/data/model/models.dart';
import 'package:pray/features/domain/entity/entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<CalenderMonth> getCalenderMonth(
      {@required String city,
      @required String country,
      @required int method,
      @required DateTime date});

  Future<CalenderMonth> getCalenderMonthByLocation(
      {@required double latitude,
      @required double longitude,
      @required int method,
      @required DateTime date});

  Future<void> saveCalenderMonth(
      {@required String key, @required String jsonString});
}

class LocalDataSourceImpl extends LocalDataSource {
  final SharedPreferences preferences;
  final calenderCashKey = 'calenderKey';
  final calenderCashKeyJson = 'jsonString';
  final emptyCalender = Future.value(CalenderMonth(code: 0, status: 'empty', data: []));

  LocalDataSourceImpl({@required this.preferences});

  String inMemoryCashedKey;  //in memory key
  String inMemoryCashedJson; //in memory json


  @override
  Future<CalenderMonth> getCalenderMonth(
      {@required String city,
      @required String country,
      @required int method,
      @required DateTime date}) {


    final String queryKey =
        '${country}_${city}_${method.toString()}_${date.month.toString()}_${date.year.toString()}';
     if(inMemoryCashedKey == null){ inMemoryCashedKey = preferences.getString(calenderCashKey);}

      if (inMemoryCashedKey == queryKey){
        if(inMemoryCashedJson == null){inMemoryCashedJson = preferences.getString(calenderCashKeyJson);}
        final calenderMonth = CalenderMonthModel.fromJson(json.decode(inMemoryCashedJson));
        return Future.value(calenderMonth);
      }else{
        return emptyCalender;
      }
  }

  @override
  Future<bool> saveCalenderMonth(
      {@required String key, @required String jsonString}) async {
    final result1 = preferences.setString(calenderCashKey, key);
    inMemoryCashedKey = key;
    final result2 = preferences.setString(calenderCashKeyJson, jsonString);
    inMemoryCashedJson = jsonString;
    return (await result1 && await result2);
  }

  @override
  Future<CalenderMonth> getCalenderMonthByLocation(
      {double latitude, double longitude, int method, DateTime date}) async {
    
    return emptyCalender;
  }
}
