import 'package:flutter_test/flutter_test.dart';
import 'package:pray/features/presentation/bloc/bloc.dart';

void main (){


  test('DayTiming should notify liseners when set is used',(){

    var value = 0;
    final DayTimings timings = DayTimings()..addListener(()=>value = 1);

    timings.selected = 1;
    expect(value, 1);

  },skip: 'Need test Service Locator');


}