import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class Failure extends Equatable{


}
class NotificationFailure extends Failure{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class ServerFailure extends Failure{
  @override
  List<Object> get props => [];
  
}

class CashFailure extends Failure{
  @override

  List<Object> get props => [];
}

class LocationFailure extends Failure with constants{

  final int id;

  LocationFailure({@required this.id});

  static const int denied = 0;

  /// The feature is disabled (or not available) on the device.
  static const int disabled = 1;

  /// Permission to access the requested feature is granted by the user.
  static const int granted = 2;

  /// The user granted restricted access to the requested feature (only on iOS).
  static const int restricted = 3;

  /// Permission is in an unknown state
  static const int unknown = 4;

  @override
  List<Object> get props => [id];
}

mixin constants{


}