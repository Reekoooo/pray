import 'dart:convert';
import 'dart:io';

Future<String> getJsonFromFile(String fileName) async{
    final rawJson = await File('/Users/saednabil/AndroidStudioProjects/pray/test/fexures/$fileName').readAsString();
    return json.encode(json.decode(rawJson));

  }