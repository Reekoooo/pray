import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pray/core/failures.dart';
import 'package:pray/features/data/data_source/local_data_source.dart';
import 'package:pray/features/data/data_source/location_data_source.dart';
import 'package:pray/features/data/data_source/nonifications_data_source.dart';
import 'package:pray/features/data/data_source/remote_data_source.dart';
import 'package:pray/features/data/repository/calender_month_repository_impl.dart';
import 'package:pray/features/domain/entity/azan_alarm.dart';
import 'package:pray/features/domain/entity/entity.dart';
import 'package:pray/features/domain/entity/location_entity.dart';
import 'package:pray/features/domain/entity/settings.dart';
import 'package:pray/features/domain/repository/calender_month_reepository.dart';
import 'package:pray/features/domain/use_cases/use_cases.dart';
import 'package:intl/intl.dart';
import 'package:pray/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DayTimings extends ChangeNotifier {
  DayTimings({@required this.repository}) {
    isLoading = true;
    _fetchTimings();
  }

  final CalenderMonthRepository repository;

  List<String> _azanTimingsStringList = ['', '', '', '', ''];
  int _selected = 0;
  int _prevSelected = 0;
  bool _isLoading;

  Future<Either<Failure, Settings>> getSettings(
      CalenderMonthRepository repository) async {
    return repository.loadSettings();
  }

  Future<Either<Failure, CalenderMonth>> getCalenderByCity(
    CalenderMonthRepository repository, {
    @required String city,
    @required String country,
    @required int method,
    @required DateTime date,
  }) {
    return repository.getMonthCalenderByCity(
      city: city,
      country: country,
      method: method,
      date: date,
    );
  }

  Future<Either<Failure, CalenderMonth>> getCalenderByLocation(
    CalenderMonthRepository repository, {
    @required double latitude,
    @required double longitude,
    @required int method,
    @required DateTime date,
  }) {
    return repository.getMonthCalenderByLocation(
      latitude: latitude,
      longitude: longitude,
      method: method,
      date: date,
    );
  }

  Future<Either<Failure, DeviceLocation>> getDeviceLocation(
      CalenderMonthRepository repository) {
    return repository.getDeviceLocation();
  }

  Future<CalenderMonth> getCalenderMonth(
      CalenderMonthRepository repository) async {
    CalenderMonth calenderMonth;
    final Either<Failure, Settings> settings = await getSettings(repository);
    final currentDate = DateTime.now();
    if (settings is Right<Failure, Settings>) {
      final String city = settings.value.city;
      final String country = settings.value.country;
      final int method = settings.value.method;
      final Either<Failure, CalenderMonth> calender = await getCalenderByCity(
        repository,
        city: city,
        country: country,
        method: method,
        date: currentDate,
      );
      if (calender is Right<Failure, CalenderMonth>) {
        calenderMonth = calender.value;
      }
    }
    // no settings stored probably initial run.
    // need to get location from GPS.

    final Either<Failure, DeviceLocation> deviceLocation =
        await getDeviceLocation(repository);
    if (deviceLocation is Right<Failure, DeviceLocation>) {
      final double longitude = deviceLocation.value.longitude;
      final double latitude = deviceLocation.value.latitude;
      //Todo get from settings
      final int method = 5;

      final calender = await getCalenderByLocation(
        repository,
        latitude: latitude,
        longitude: longitude,
        method: method,
        date: currentDate,
      );
      if (calender is Right<Failure, CalenderMonth>) {
        calenderMonth = calender.value;
      }
    } else {
      //couldn't get location from GPS get it manually from user.

    }

    return Future.value(calenderMonth);
  }

  _fetchTimings() async {
    final calenderMonth = await getCalenderMonth(repository); //await compute(getCalenderMonth,repository);
    final currentDate = DateTime.now();
//
//    final Either<Failure, Settings> settings = await getSettings(repository);
//    //final currentDate = DateTime.now();
//    if (settings is Right<Failure, Settings>) {
//      final String city = settings.value.city;
//      final String country = settings.value.country;
//      final int method = settings.value.method;
//      final Either<Failure, CalenderMonth> calender = await getCalenderByCity(
//        repository,
//        city: city,
//        country: country,
//        method: method,
//        date: currentDate,
//      );
//      if (calender is Right<Failure, CalenderMonth>) {
//        calenderMonth = calender.value;
//      }
//    } else {
//      // no settings stored probably initial run.
//      // need to get location from GPS.
//
//      final Either<Failure, DeviceLocation> deviceLocation = await getDeviceLocation(repository);
//      if (deviceLocation is Right<Failure, DeviceLocation>) {
//        final double longitude = deviceLocation.value.longitude;
//        final double latitude = deviceLocation.value.latitude;
//        //Todo get from settings
//        final int method = 5;
//
//        final calender = await getCalenderByLocation(
//          repository,
//          latitude: latitude,
//          longitude: longitude,
//          method: method,
//          date: currentDate,
//        );
//        if(calender is Right<Failure,CalenderMonth>){
//          calenderMonth = calender.value;
//        }
//      }else{
//        //couldn't get location from GPS get it manually from user.
//
//      }
//    }

    final t = calenderMonth.data[currentDate.day - 1];

    _azanTimingsStringList = [
      _formatTime(t.timings.fajr),
      _formatTime(t.timings.dhuhr),
      _formatTime(t.timings.asr),
      _formatTime(t.timings.maghrib),
      _formatTime(t.timings.isha),
    ];

    final _timingsAsDates = _azanTimingsStringList.map((timeString) {
      final format = new DateFormat("dd-MM-yyyy hh:mm:ss");
      final dateTimeString = "${t.date.gregorian.date} $timeString:00";
      final dateTime = format.parse(dateTimeString, true);

      return dateTime.toLocal();
    }).toList();

    _azanTimingsStringList = _timingsAsDates
        .map((dateTime) => DateFormat.jm().format(dateTime))
        .toList();

    // print(_timingsAsDates);

    final activeAzan =
        _timingsAsDates.indexWhere((e) => e.isAfter(DateTime.now()));
    //print(DateFormat.jm().format(DateTime.now()));
    //print(active);
    selected = activeAzan;

    //print(_timingsAsDates);

    isLoading = false;

    _setAzanAlarms([
      DateTime.now().add(Duration(seconds: 20)),
      DateTime.now().add(Duration(seconds: 30)),
      DateTime.now().add(Duration(seconds: 40)),
      DateTime.now().add(Duration(seconds: 50)),
      DateTime.now().add(Duration(seconds: 60)),
    ]);
    //  print('Failure fetching Server');
  }

  String _formatTime(String time) {
    return time.split(" (")[0];
  }

  set selected(int value) {
    _prevSelected = _selected;
    if (value != _selected) {
      _selected = value;
      // notifyListeners();
    }
  }

  int get selected => _selected;

  int get prevSelected => _prevSelected;

  get timings => _azanTimingsStringList;

  set timings(List<String> value) {
    if (value != _azanTimingsStringList) {
      _azanTimingsStringList = value;
      notifyListeners();
    }
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    if (value != _isLoading) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void onTap(int index) {
    if (_selected != index) {
      selected = index;
    }
  }

  void _setAzanAlarms(List<DateTime> timingsAsDates) async {
    final notifications =
//    timingsAsDates
//        .map((time) => AzanAlarm(
//              azanDateTime: time,
//            ))
//        .toList()
        [AzanAlarm(azanDateTime: DateTime.now().add(Duration(seconds: 10)))];
    // await notificationsUseCase.setNotifications(notifications: notifications);
  }
}
