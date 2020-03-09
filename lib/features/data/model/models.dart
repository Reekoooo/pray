import 'package:flutter/foundation.dart';
import 'package:pray/features/domain/entity/entity.dart';

class CalenderMonthModel extends CalenderMonth {

  CalenderMonthModel({
    @required int code,
    @required String status,
    @required List<DataModel> data,
  }) :super(
    code: code,
    status: status,
    data: data,
  );

  factory CalenderMonthModel.fromJson(Map<String, dynamic> json) {
    List<DataModel> dataList ;
     if (json['data'] != null) {
         dataList = List<DataModel>();
         json['data'].forEach((v) {
           dataList.add(new DataModel.fromJson(v));
         });
       }
    return CalenderMonthModel(
        code: json['code'],
        status: json['status'],
        data: dataList,

//    if (json['data'] != null) {
//      data = new List<DataModel>();
//      json['data'].forEach((v) {
//        data.add(new DataModel.fromJson(v));
//      });
//    }
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => (v as DataModel).toJson()).toList();
    }
    return data;
  }
}

class DataModel extends Data {
  DataModel({
    @required TimingsModel timings,
    @required DateModel date,
    @required MetaModel meta,
  }) : super(
    timings: timings,
    date: date,
    meta: meta,
  );

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      timings: json['timings'] != null
          ? new TimingsModel.fromJson(json['timings'])
          : null,
      date: json['date'] != null ? new DateModel.fromJson(json['date']) : null,
      meta: json['meta'] != null ? new MetaModel.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timings != null) {
      data['timings'] = (this.timings as TimingsModel).toJson();
    }
    if (this.date != null) {
      data['date'] = (this.date as DateModel).toJson();
    }
    if (this.meta != null) {
      data['meta'] = (this.meta as MetaModel).toJson();
    }
    return data;
  }
}

class TimingsModel extends Timings {
  TimingsModel({@required String fajr,
    @required String sunrise,
    @required String dhuhr,
    @required String asr,
    @required String sunset,
    @required String maghrib,
    @required String isha,
    @required String imsak,
    @required String midnight})
      : super(
      fajr: fajr,
      sunrise: sunrise,
      dhuhr: dhuhr,
      asr: asr,
      sunset: sunset,
      maghrib: maghrib,
      isha: isha,
      imsak: imsak,
      midnight: midnight);

  factory TimingsModel.fromJson(Map<String, dynamic> json) {
    return TimingsModel(
      fajr: json['Fajr'],
      sunrise: json['Sunrise'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      sunset: json['Sunset'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
      imsak: json['Imsak'],
      midnight: json['Midnight'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Fajr'] = this.fajr;
    data['Sunrise'] = this.sunrise;
    data['Dhuhr'] = this.dhuhr;
    data['Asr'] = this.asr;
    data['Sunset'] = this.sunset;
    data['Maghrib'] = this.maghrib;
    data['Isha'] = this.isha;
    data['Imsak'] = this.imsak;
    data['Midnight'] = this.midnight;
    return data;
  }
}

class DateModel extends Date {
  DateModel({
    @required String readable,
    @required String timestamp,
    @required GregorianModel gregorian,
    @required HijriModel hijri,
  }) : super(
    readable: readable,
    timestamp: timestamp,
    gregorian: gregorian,
    hijri: hijri,
  );

  factory DateModel.fromJson(Map<String, dynamic> json) {
    return DateModel(
      readable: json['readable'],
      timestamp: json['timestamp'],
      gregorian: json['gregorian'] != null
          ? new GregorianModel.fromJson(json['gregorian'])
          : null,
      hijri:
      json['hijri'] != null ? new HijriModel.fromJson(json['hijri']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['readable'] = this.readable;
    data['timestamp'] = this.timestamp;
    if (this.gregorian != null) {
      data['gregorian'] = (this.gregorian as GregorianModel).toJson();
    }
    if (this.hijri != null) {
      data['hijri'] = (this.hijri as HijriModel).toJson();
    }
    return data;
  }
}

class GregorianModel extends Gregorian {
  GregorianModel({String date,
    String format,
    String day,
    GWeekdayModel weekday,
    GMonthModel month,
    String year,
    DesignationModel designation})
      : super(
    date: date,
    format: format,
    day: day,
    weekday: weekday,
    month: month,
    year: year,
    designation: designation,
  );

  factory GregorianModel.fromJson(Map<String, dynamic> json) {
    return GregorianModel(
      date: json['date'],
      format: json['format'],
      day: json['day'],
      weekday: json['weekday'] != null
          ? new GWeekdayModel.fromJson(json['weekday'])
          : null,
      month: json['month'] != null
          ? new GMonthModel.fromJson(json['month'])
          : null,
      year: json['year'],
      designation: json['designation'] != null
          ? new DesignationModel.fromJson(json['designation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['format'] = this.format;
    data['day'] = this.day;
    if (this.weekday != null) {
      data['weekday'] = (this.weekday as GWeekdayModel).toJson();
    }
    if (this.month != null) {
      data['month'] = (this.month as GMonthModel).toJson();
    }
    data['year'] = this.year;
    if (this.designation != null) {
      data['designation'] = (this.designation as DesignationModel).toJson();
    }
    return data;
  }
}

class GWeekdayModel extends GWeekday {
  GWeekdayModel({@required String en}) : super(en: en);

  factory GWeekdayModel.fromJson(Map<String, dynamic> json) {
    return GWeekdayModel(
      en: json['en'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}

class GMonthModel extends GMonth {
  GMonthModel({@required int number, @required String en})
      : super(number: number, en: en);

  factory GMonthModel.fromJson(Map<String, dynamic> json) {
    return GMonthModel(
      number: json['number'],
      en: json['en'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['en'] = this.en;
    return data;
  }
}

class DesignationModel extends Designation {
  DesignationModel({@required String abbreviated, @required String expanded})
      : super(
    abbreviated: abbreviated,
    expanded: expanded,
  );

  factory DesignationModel.fromJson(Map<String, dynamic> json) {
    return DesignationModel(
      abbreviated: json['abbreviated'],
      expanded: json['expanded'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['abbreviated'] = this.abbreviated;
    data['expanded'] = this.expanded;
    return data;
  }
}

class HijriModel extends Hijri {
  HijriModel({@required String date,
    @required String format,
    @required String day,
    @required WeekdayModel weekday,
    @required MonthModel month,
    @required String year,
    @required DesignationModel designation,
    @required List<String> holidays})
      : super(
      date: date,
      format: format,
      day: day,
      weekday: weekday,
      month: month,
      year: year,
      designation: designation,
      holidays: holidays);

  factory HijriModel.fromJson(Map<String, dynamic> json) {
    return HijriModel(
      date: json['date'],
      format: json['format'],
      day: json['day'],
      weekday: json['weekday'] != null
          ? new WeekdayModel.fromJson(json['weekday'])
          : null,
      month:
      json['month'] != null ? new MonthModel.fromJson(json['month']) : null,
      year: json['year'],
      designation: json['designation'] != null
          ? new DesignationModel.fromJson(json['designation'])
          : null,
      holidays: json['holidays'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['format'] = this.format;
    data['day'] = this.day;
    if (this.weekday != null) {
      data['weekday'] = (this.weekday as WeekdayModel).toJson();
    }
    if (this.month != null) {
      data['month'] = (this.month as MonthModel).toJson();
    }
    data['year'] = this.year;
    if (this.designation != null) {
      data['designation'] = (this.designation as DesignationModel).toJson();
    }
    data['holidays'] = this.holidays;
    return data;
  }
}

class WeekdayModel extends Weekday {
  WeekdayModel({@required String en, @required String ar})
      : super(
    en: en,
    ar: ar,
  );

  factory WeekdayModel.fromJson(Map<String, dynamic> json) {
    return WeekdayModel(
      en: json['en'],
      ar: json['ar'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

class MonthModel extends Month {
  MonthModel({@required int number, @required String en, @required String ar})
      : super(
    number: number,
    en: en,
    ar: ar,
  );

  factory MonthModel.fromJson(Map<String, dynamic> json) {
    return MonthModel(
      number: json['number'],
      en: json['en'],
      ar: json['ar'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

class MetaModel extends Meta {
  MetaModel({double latitude,
    double longitude,
    String timezone,
    MethodModel method,
    String latitudeAdjustmentMethod,
    String midnightMode,
    String school,
    OffsetModel offset})
      : super(
    latitude: latitude,
    longitude: longitude,
    timezone: timezone,
    method: method,
    latitudeAdjustmentMethod: latitudeAdjustmentMethod,
    midnightMode: midnightMode,
    school: school,
    offset: offset,
  );

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timezone: json['timezone'],
      method: json['method'] != null
          ? new MethodModel.fromJson(json['method'])
          : null,
      latitudeAdjustmentMethod: json['latitudeAdjustmentMethod'],
      midnightMode: json['midnightMode'],
      school: json['school'],
      offset: json['offset'] != null
          ? new OffsetModel.fromJson(json['offset'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['timezone'] = this.timezone;
    if (this.method != null) {
      data['method'] = (this.method as MethodModel).toJson();
    }
    data['latitudeAdjustmentMethod'] = this.latitudeAdjustmentMethod;
    data['midnightMode'] = this.midnightMode;
    data['school'] = this.school;
    if (this.offset != null) {
      data['offset'] = (this.offset as OffsetModel).toJson();
    }
    return data;
  }
}

class MethodModel extends Method {
  MethodModel({
    @required int id,
    @required String name,
    @required ParamsModel params,
  }) : super(id: id, name: name, params: params);

  factory MethodModel.fromJson(Map<String, dynamic> json) {
    return MethodModel(
      id: json['id'],
      name: json['name'],
      params: json['params'] != null
          ? new ParamsModel.fromJson(json['params'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.params != null) {
      data['params'] = (this.params as ParamsModel).toJson();
    }
    return data;
  }
}

class ParamsModel extends Params {
  ParamsModel({
    @required num fajr,
    @required num isha,
  }) : super(fajr: fajr, isha: isha);

  factory ParamsModel.fromJson(Map<String, dynamic> json) {
    return ParamsModel(
      fajr: json['Fajr'],
      isha: json['Isha'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Fajr'] = this.fajr;
    data['Isha'] = this.isha;
    return data;
  }
}

class OffsetModel extends Offset {
  OffsetModel({@required int imsak,
    @required int fajr,
    @required int sunrise,
    @required int dhuhr,
    @required int asr,
    @required int maghrib,
    @required int sunset,
    @required int isha,
    @required int midnight})
      : super(
    imsak: imsak,
    fajr: fajr,
    sunrise: sunrise,
    dhuhr: dhuhr,
    asr: asr,
    maghrib: maghrib,
    sunset: sunset,
    isha: isha,
    midnight: midnight,
  );

  factory OffsetModel.fromJson(Map<String, dynamic> json) {
    return OffsetModel(
      imsak: json['Imsak'],
      fajr: json['Fajr'],
      sunrise: json['Sunrise'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      sunset: json['Sunset'],
      isha: json['Isha'],
      midnight: json['Midnight'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Imsak'] = this.imsak;
    data['Fajr'] = this.fajr;
    data['Sunrise'] = this.sunrise;
    data['Dhuhr'] = this.dhuhr;
    data['Asr'] = this.asr;
    data['Maghrib'] = this.maghrib;
    data['Sunset'] = this.sunset;
    data['Isha'] = this.isha;
    data['Midnight'] = this.midnight;
    return data;
  }
}
