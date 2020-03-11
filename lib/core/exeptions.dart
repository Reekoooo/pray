 import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}
 class CashException implements Exception {}
 class NotificationsException implements Exception {}
 class LocationException extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}