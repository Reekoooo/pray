import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pray/core/exeptions.dart';
import 'package:pray/features/data/data_source/local_data_source.dart';
import 'package:pray/features/data/model/models.dart';
import 'package:pray/features/data/model/settings_model.dart';
import 'package:pray/features/domain/entity/entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/jsonutil.dart';

class SharedPreferencesMock extends Mock implements SharedPreferences {}

void main() {
  SharedPreferences preferences;
  LocalDataSourceImpl local;

  setUp(() {
    preferences = SharedPreferencesMock();
    local = LocalDataSourceImpl(preferences: preferences);
  });

  group('get calender month', () {
    test('get calender month should return calender month if parameters matches the key', () async {
      final savedKey = 'Egypt_Alexandria_0_2_2020';
      final calenderCashKey = 'calenderKey';
      final calenderCashKeyJson = 'jsonString';
      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));
      final data = calender;
      when(preferences.getString(calenderCashKey)).thenReturn(savedKey);
      when(preferences.getString(calenderCashKeyJson)).thenReturn(testJson);
      final actual = await local.getCalenderMonthByCity(
          city: 'Alexandria',
          country: 'Egypt',
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30));

      expect(actual, data);
    });
    test('get calender month should returm empty calender when not saved',() async{
      final savedKey = 'Egypt_Alexandria_0_3_2020';
      final calenderCashKey = 'calenderKey';
      //final calenderCashKeyJson = 'jsonString';
      final calender = CalenderMonth(code: 0, status: 'empty', data: []);
      final data = calender;

      when(preferences.getString(calenderCashKey)).thenReturn(savedKey);
      final actual = await local.getCalenderMonthByCity(
          city: 'Alexandria',
          country: 'Egypt',
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30));
      expect(actual, data);

    });
  });

  group('save calender month', () {

    test('save calender month should call set String method', () async {
      final calenderCashKey = 'calenderKey';
      final calenderCashKeyJson = 'jsonString';
      when(preferences.setString(any, any))
          .thenAnswer((_) => Future.value(true));
      final actual =
          await local.saveCalenderMonth(key: 'key', jsonString: 'string');

      expect(actual, true);
      verify(preferences.setString(calenderCashKey, 'key'));
      verify(preferences.setString(calenderCashKeyJson, 'string'));
    });
  });

  group('settings', (){

    test('local data source should return settings',() async{
      final settings = SettingsModel(city: 'Alexandria',country: 'Egypt');
      final jsonString = json.encode( settings.toJson());
      when(preferences.getString('settings')).thenReturn(jsonString);

      final actual = await local.loadSettings();

      expect(actual,settings);
    });

    test('throw cash exception when no settings saved', () async{
      when(preferences.getString('settings')).thenThrow(Exception());
      final actual = ()=> local.loadSettings();
      expect(actual, throwsA(CashException()));

    });

    test('local data source save settings', () async{
      final settings = SettingsModel(city: 'Alexandria',country: 'Egypt');
      when(preferences.setString(any,any)).thenAnswer((_)=>Future.value(true));
      await local.saveSettings(settingsModel: settings);
      final jsonString = json.encode(settings.toJson());

      verify(preferences.setString('settings', jsonString));
    });

    test('throw cash exception when save error', () async{
      final settings = SettingsModel(city: 'Alexandria',country: 'Egypt');
      when(preferences.setString(any,any)).thenThrow(Exception());
      final actual = () => local.saveSettings(settingsModel: settings);
      expect(actual,throwsA(CashException()));
    });
  });
}
