import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pray/core/exeptions.dart';
import 'package:pray/features/data/data_source/remote_data_source.dart';
import 'package:pray/features/data/model/models.dart';
import 'package:path/path.dart' as path;
import '../../../core/jsonutil.dart';

// http://api.aladhan.com/v1/calendarByCity?city=London&country=United%20Kingdom&method=2&month=04&year=2017
// final url = 'http://api.aladhan.com/v1/calendarByCity?city=Alexandria&country=Egypt&method=0&month=2&year=2020';
void main() {
  http.Client client;
  RemoteDataSource remote;
  String pathString;
  final dir = (path.dirname(Platform.script.toFilePath()));
  if(dir.endsWith('/test')){
    pathString = 'fexures/';
  }else{
    pathString = 'test/fexures/';
  }

  group('get remote calender by city', () {
    test('get list of data when called with correct parameters', () async {
      final rawJson = await File('${pathString}calendermonth.json').readAsString();
      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));

      client = MockClient((req) async {
        return http.Response(rawJson, 200);
      });
      remote = RemoteDataSourceImpl(client: client);

      final actual = await remote.getCalenderMonthByCity(
          city: 'Alexandria',
          country: 'Egypt',
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30));

      expect(actual, calender);
    });

    test('should throw Server Exception when bad request happens', () async {
      final rawJson = await File('${pathString}bad_request.json').readAsString();
      client = MockClient((req) async {
        return http.Response(rawJson, 400);
      });
      remote = RemoteDataSourceImpl(client: client);
      final actual = () => remote.getCalenderMonthByCity(
          city: 'Alexandria',
          country: 'Egypt',
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30));
      expect(actual, throwsA(ServerException()));
    });
  });

  group('get remote calender by location', () {
    test('get list of data when called with correct parameters', () async {
      //print(dir);
      final rawJson = await File('${pathString}calendermonth.json').readAsString();
      client = MockClient((req) async {
        return http.Response(rawJson, 200);
      });
      remote = RemoteDataSourceImpl(client: client);

      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));
      final actual = await remote.getCalenderMonthByLocation(
          latitude: 31.1039,
          longitude: 29.7698,
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30));
      expect(actual, calender);
    });

    test('should throw Server Exception when bad request happens', () async {
      final rawJson = await File('${pathString}bad_request.json').readAsString();
      client = MockClient((req) async {
        return http.Response(rawJson, 400);
      });
      remote = RemoteDataSourceImpl(client: client);
      final actual = () => remote.getCalenderMonthByLocation(
          latitude: 31.1039,
          longitude: 29.7698,
          method: 0,
          date: DateTime(2020, 2, 16, 12, 30));
      expect(actual, throwsA(ServerException()));
    });
  });
}
