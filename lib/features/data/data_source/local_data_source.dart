import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pray/core/exeptions.dart';
import 'package:pray/features/data/model/models.dart';
import 'package:pray/features/data/model/settings_model.dart';
import 'package:pray/features/domain/entity/entity.dart';
import 'package:pray/features/domain/entity/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
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

  Future<void> saveCalenderMonth(
      {@required String key, @required String jsonString});

  Future<Settings> loadSettings();
  Future<void> saveSettings({@required SettingsModel settingsModel});
}

class LocalDataSourceImpl extends LocalDataSource {
  final SharedPreferences preferences;
  final calenderCashKey = 'calenderKey';
  final calenderCashKeyJson = 'jsonString';
  final emptyCalender =
      Future.value(CalenderMonth(code: 0, status: 'empty', data: []));

  LocalDataSourceImpl({@required this.preferences});

  String inMemoryCashedKey; //in memory key
  String inMemoryCashedJson; //in memory json

  //Todo need more investigation for isolates
  static parseCalender (String jsonString){
    return CalenderMonthModel.fromJson(json.decode(jsonString));
  }

  //Todo investigate on passing mock objects to another isolate
  // not used for now
  static String readPreferences(Map<String,dynamic> args) {
    final SharedPreferences preferences = args['preferences'];
    final String key = args['key'];
    return preferences.getString(key);
  }

  @override
  Future<CalenderMonth> getCalenderMonthByCity({
    @required String city,
    @required String country,
    @required int method,
    @required DateTime date,
  }) async{

    final String queryKey =
        '${country}_${city}_${method.toString()}_${date.month.toString()}_${date.year.toString()}';
    if (inMemoryCashedKey == null) {
      inMemoryCashedKey = preferences.getString(calenderCashKey);
    }

    if (inMemoryCashedKey == queryKey) {
      if (inMemoryCashedJson == null) {
        // not used for now as it can not be tested
        //final Map<String,dynamic> args = {'preferences':preferences,'key':calenderCashKeyJson};
        inMemoryCashedJson = //await compute(readPreferences,args);
        preferences.getString(calenderCashKeyJson);
      }
      final calenderMonth =
          await compute(parseCalender,inMemoryCashedJson);
          //CalenderMonthModel.fromJson(json.decode(inMemoryCashedJson));
      return Future.value(calenderMonth);
    } else {
      return emptyCalender;
    }
  }

  //can use compute but need figuring out how to test
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

  @override
  Future<Settings> loadSettings() {
    try{
      final settings = preferences.getString('settings');
      final settingsMap = json.decode(settings);
      final future = SettingsModel.fromJson(settingsMap);
      return Future.value(future);
    } catch (e){
      throw CashException();
    }

  }

  @override
  Future<void> saveSettings({SettingsModel settingsModel}) async{
    try{
      final jsonString = json.encode(settingsModel.toJson());
      await preferences.setString('settings', jsonString);
      return Future.value(null);
    }  catch (e){
      throw CashException();
    }
  }


}
