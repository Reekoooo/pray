import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pray/features/data/model/models.dart';

import '../../../core/jsonutil.dart';

void main() {

  test('ClenderMonth model should return the same json fromjson tojson ', () async {

    final testJson = await getJsonFromFile('calendermonth.json');
    final decoded = CalenderMonthModel.fromJson(json.decode(testJson));
    final encoded = json.encode(decoded.toJson());
    //assert
    expect(encoded, testJson);
  });

  test('OffsetModel should return the same json fromjson tojson ', () async {
    final testJson = await getJsonFromFile('offset.json');
    final decoded = OffsetModel.fromJson(json.decode(testJson));
    final encoded = json.encode(decoded.toJson());
    expect(encoded, testJson);
  });

  test('ParamsModel should return the same json fromjson tojson', () async {
    final testJson = await getJsonFromFile('params.json');
    final decoded = ParamsModel.fromJson(json.decode(testJson));
    final encoded = json.encode(decoded.toJson());
    expect(encoded, testJson);
  });

  test('Method model should return correct json ', () async {
    final testJson = await getJsonFromFile('method.json');
    final decoded = MethodModel.fromJson(json.decode(testJson));
    final encoded = json.encode(decoded.toJson());
    expect(encoded, testJson);
  });

  test('MetaModel should return the same json fromjson tojson', () async {
    final testJson = await getJsonFromFile('meta.json');
    final decoded = MetaModel.fromJson(json.decode(testJson));
    final encoded = json.encode(decoded.toJson());
    expect(encoded, testJson);
  });
}










