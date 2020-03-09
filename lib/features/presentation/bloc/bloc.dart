import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pray/core/failures.dart';
import 'package:pray/features/domain/entity/azan_alarm.dart';
import 'package:pray/features/domain/entity/entity.dart';
import 'package:pray/features/domain/repository/calender_month_reepository.dart';
import 'package:pray/features/domain/use_cases/use_cases.dart';
import 'package:intl/intl.dart';

class DayTimings extends ChangeNotifier {
  DayTimings({@required this.repository})
      : todayUseCase = GetCalenderToDayUseCase(repository: repository),
        todayLocationUseCase =
            GetCalenderTodayByLocationUseCase(repository: repository),
  monthCurrentLocationUseCase = GetCalenderMonthForCurrentLocation(repository: repository),
        notificationsUseCase =
            SetAzanNotificationsUseCase(repository: repository) {
    isLoading = true;
    _fetchTimings();
  }

  final CalenderMonthRepository repository;
  final GetCalenderToDayUseCase todayUseCase;
  final GetCalenderTodayByLocationUseCase todayLocationUseCase;
  final GetCalenderMonthForCurrentLocation monthCurrentLocationUseCase;
  final SetAzanNotificationsUseCase notificationsUseCase;

  List<String> _azanTimingsStringList = ['', '', '', '', ''];
  int _selected = 0;
  int _prevSelected = 0;
  bool _isLoading;

  _fetchTimings() async {
    final calender =
        await todayLocationUseCase.getTodayCalenderByLocation(method: 5);
    if (calender is Right) {
      final t = (((calender as Right).value) as Data);

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

      print(_timingsAsDates);

      final activeAzan =
          _timingsAsDates.indexWhere((e) => e.isAfter(DateTime.now()));
      print(DateFormat.jm().format(DateTime.now()));
      //print(active);
      selected = activeAzan;

      print(_timingsAsDates);

      isLoading = false;

      _setAzanAlarms([
        DateTime.now().add(Duration(seconds: 20)),
        DateTime.now().add(Duration(seconds: 30)),
        DateTime.now().add(Duration(seconds: 40)),
        DateTime.now().add(Duration(seconds: 50)),
        DateTime.now().add(Duration(seconds: 60)),
      ]);



      return;
    }
    print('Failure fetching Server');
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
    await notificationsUseCase.setNotifications(notifications: notifications);
  }
}
