import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pray/features/data/data_source/remote_data_source.dart';
import 'package:pray/features/data/model/models.dart';
import '../../../core/jsonutil.dart';

void main() {
  http.Client client;
  RemoteDataSource remote;

  setUp(() async{
    final rawJson = await File('./test/fexures/calendermonth.json').readAsString();
    client = MockClient((req) async{
      return http.Response(rawJson,200);
    });
    remote = RemoteDataSourceImpl(client: client);
  });

  group('get remote calender', () {
    test('get list of data when called with correct parameters', () async {

      final testJson = await getJsonFromFile('calendermonth.json');
      final calender = CalenderMonthModel.fromJson(json.decode(testJson));



      final actual = await remote.getCalenderMonthByCity(
        city: 'Alexandria', country: 'Egypt', method: 0, date: DateTime(2020, 2, 16, 12,30));

// http://api.aladhan.com/v1/calendarByCity?city=London&country=United%20Kingdom&method=2&month=04&year=2017
// final url = 'http://api.aladhan.com/v1/calendarByCity?city=Alexandria&country=Egypt&method=0&month=2&year=2020';
        expect(actual, calender);
    });
  });
}
