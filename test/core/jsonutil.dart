import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;



//  add 'test/' before 'fexures/$fileName' so you can test individual tests
// somehow relative path of the fixures depend on the place you run the test from
// if you run from command line it will append 'test' to the path.



Future<String> getJsonFromFile(String fileName) async {
  String pathString;
  final dir = (path.dirname(Platform.script.toFilePath()));
  if(dir.endsWith('/test')){
    pathString = 'fexures/';
  }else{
    pathString = 'test/fexures/';
  }
  //print(dir);
  final rawJson =
      await File('$pathString$fileName').readAsString();
  return json.encode(json.decode(rawJson));
}
