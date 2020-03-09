import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CalenderMonth extends Equatable {
  @required
  final int code;
  @required
  final String status;
  @required
  final List<Data> data;

  CalenderMonth({this.code, this.status, this.data});

  @override
  List<Object> get props => [code, status, data];
}

class Data extends Equatable {
  @required
  final Timings timings;
  @required
  final Date date;
  @required
  final Meta meta;

  Data({this.timings, this.date, this.meta});

  @override
  List<Object> get props => [timings, date, meta];
}

class Timings extends Equatable {
  @required
  final String fajr;
  @required
  final String sunrise;
  @required
  final String dhuhr;
  @required
  final String asr;
  @required
  final String sunset;
  @required
  final String maghrib;
  @required
  final String isha;
  @required
  final String imsak;
  @required
  final String midnight;

  Timings(
      {this.fajr,
      this.sunrise,
      this.dhuhr,
      this.asr,
      this.sunset,
      this.maghrib,
      this.isha,
      this.imsak,
      this.midnight});

  @override
  List<Object> get props =>
      [fajr, sunrise, dhuhr, asr, sunset, maghrib, isha, imsak, midnight];
}

class Date extends Equatable{
  @required
  final String readable;
  @required
  final String timestamp;
  @required
  final Gregorian gregorian;
  @required
  final Hijri hijri;

  Date({
    this.readable,
    this.timestamp,
    this.gregorian,
    this.hijri,
  });

  @override
  List<Object> get props => [readable,timestamp,gregorian,hijri];
}

class Gregorian extends Equatable{
  @required
  final String date;
  @required
  final String format;
  @required
  final String day;
  @required
  final GWeekday weekday;
  @required
  final GMonth month;
  @required
  final String year;
  @required
  final Designation designation;

  Gregorian(
      {this.date,
      this.format,
      this.day,
      this.weekday,
      this.month,
      this.year,
      this.designation});

  @override
  List<Object> get props => [date,format,day,weekday,month,year,designation];
}

class GWeekday extends Equatable{
  @required
  final String en;

  GWeekday({this.en});

  @override
  List<Object> get props => [en];
}

class GMonth extends Equatable{
  @required
  final int number;
  @required
  final String en;

  GMonth({this.number, this.en});

  @override
  List<Object> get props => [number,en];
}

class Designation extends Equatable{
  @required
  final String abbreviated;
  @required
  final String expanded;

  Designation({this.abbreviated, this.expanded});

  @override
  List<Object> get props => [abbreviated,expanded];
}

class Hijri extends Equatable{
  @required
  final String date;
  @required
  final String format;
  @required
  final String day;
  @required
  final Weekday weekday;
  @required
  final Month month;
  @required
  final String year;
  @required
  final Designation designation;
  @required
  final List<String> holidays;

  Hijri(
      {this.date,
      this.format,
      this.day,
      this.weekday,
      this.month,
      this.year,
      this.designation,
      this.holidays});

  @override
  List<Object> get props => [date,format,day,weekday,month,year,designation,holidays];
}

class Weekday extends Equatable{
  @required
  final String en;
  @required
  final String ar;

  Weekday({
    this.en,
    this.ar,
  });

  @override
  List<Object> get props => [en,ar];
}

class Month extends Equatable{
  @required
  final int number;
  @required
  final String en;
  @required
  final String ar;

  Month({
    this.number,
    this.en,
    this.ar,
  });

  @override
  List<Object> get props => [number,en,ar];
}

class Meta extends Equatable{
  @required
  final double latitude;
  @required
  final double longitude;
  @required
  final String timezone;
  @required
  final Method method;
  @required
  final String latitudeAdjustmentMethod;
  @required
  final String midnightMode;
  @required
  final String school;
  @required
  final Offset offset;

  Meta(
      {this.latitude,
      this.longitude,
      this.timezone,
      this.method,
      this.latitudeAdjustmentMethod,
      this.midnightMode,
      this.school,
      this.offset});

  @override
  List<Object> get props => [latitude,longitude,timezone,method,latitudeAdjustmentMethod,midnightMode,school,offset];
}

class Method extends Equatable{
  @required
  final int id;
  @required
  final String name;
  @required
  final Params params;

  Method({this.id, this.name, this.params});

  @override
  List<Object> get props => [id,name,params];
}

class Params extends Equatable{
  @required
  final num fajr;
  @required
  final num isha;

  Params({this.fajr, this.isha});

  @override
  List<Object> get props => [fajr,isha];
}

class Offset extends Equatable{
  @required
  final int imsak;
  @required
  final int fajr;
  @required
  final int sunrise;
  @required
  final int dhuhr;
  @required
  final int asr;
  @required
  final int maghrib;
  @required
  final int sunset;
  @required
  final int isha;
  @required
  final int midnight;

  Offset(
      {this.imsak,
      this.fajr,
      this.sunrise,
      this.dhuhr,
      this.asr,
      this.maghrib,
      this.sunset,
      this.isha,
      this.midnight});

  @override
  List<Object> get props => [imsak,fajr,sunrise,dhuhr,asr,maghrib,sunset,isha,midnight];
}
