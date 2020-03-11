import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pray/core/failures.dart';
import 'package:pray/features/domain/entity/azan_alarm.dart';
import 'package:pray/features/domain/entity/entity.dart';
import 'package:pray/features/domain/repository/calender_month_reepository.dart';




class GetCalenderMonthUseCase {
  final CalenderMonthRepository repository;

  GetCalenderMonthUseCase({@required this.repository});

  Future<Either<Failure, CalenderMonth>> getMonthCalender(
      {@required String city, @required String country, int method, DateTime date}) {
    return repository.getMonthCalender(
        city: city, country: country, method: method, date: date);
  }
}

class GetCalenderMonthForCurrentLocation{
  final CalenderMonthRepository repository;

  GetCalenderMonthForCurrentLocation({@required this.repository});

  Future<Either<Failure,CalenderMonth>> getMonthCalenderForCurrentLocation({@required int method, DateTime date}){
    return repository.getMonthCalenderForCurrentLocation(method: method, date: date);
  }
}

class GetCalenderToDayUseCase {
  final CalenderMonthRepository repository;

  GetCalenderToDayUseCase({@required this.repository});

  Future<Either<Failure, Data>> getTodayCalender(
      {@required String city, @required String country, @required int method}) {
    return repository.getDayCalender(
        city: city, country: country, method: method, date: DateTime.now());
  }
}

class GetCalenderMonthByLocation {
  final CalenderMonthRepository repository;

  GetCalenderMonthByLocation({@required this.repository});

  Future<Either<Failure, CalenderMonth>> getMonthCalenderByLocation({double longitude,double latitude,@required int method,@required DateTime date}) {
    return repository.getMonthCalenderByLocation(latitude: latitude, longitude: longitude, method: method, date: date);
  }
}

class GetCalenderTodayByLocationUseCase {
  final CalenderMonthRepository repository;

  GetCalenderTodayByLocationUseCase({@required this.repository});

  Future<Either<Failure, Data>> getTodayCalenderByLocation({double longitude,double latitude,@required int method}){
        return repository.getDayCalenderByLocation(longitude: longitude, latitude: latitude, method: method, date: DateTime.now());
  }

}
class SetAzanNotificationsUseCase {
  final CalenderMonthRepository repository;

  SetAzanNotificationsUseCase({@required this.repository});

  Future<Either<Failure,bool>> setNotifications({@required List<AzanAlarm> notifications }){
    return repository.setAzanNotifications(notifications: notifications);
  }

}

class CalenderUseCases {

}
