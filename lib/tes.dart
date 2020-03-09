import 'dart:async';

void main() {

  final folder1 = Future.value({"a","b","c","d"});
  final folder2 = Future.value({"a","b","c","d",folder1});
  final folder3 = {"a","b","c","d",folder1,folder2}; //what you get initially

  Stream printElement(list) async*{

    for(dynamic element in list){

      if(element is String){
        yield element;
      }else{
        yield* printElement(await(element));  //make your http call here for your nested folder
      }

    }
  }

  printElement(folder3)
      .listen(
          (element){
            print(element);
          });

}