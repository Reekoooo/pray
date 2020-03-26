import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final String city;
  final String country;
  final int method;

  Settings({this.city, this.country,this.method});

  @override
  List<Object> get props => [city,country,method];
  
}