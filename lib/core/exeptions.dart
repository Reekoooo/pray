import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ServerException extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}
 class CashException extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}
 class NotificationsException implements Exception {}

 class LocationException extends Equatable implements Exception {
  final int id;

  LocationException({@required this.id});

  @override
  List<Object> get props => [id];
}

