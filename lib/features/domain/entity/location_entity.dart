import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class DeviceLocation extends Equatable {
  final double latitude;
  final double longitude;

  DeviceLocation({
    @required this.latitude,
    @required this.longitude,
  });

  @override
  List<Object> get props => [
        latitude,
        longitude,
      ];
}

class DevicePlaceMark extends Equatable {
  final String country;
  final String city;

  DevicePlaceMark({
    @required this.country,
    @required this.city,
  });

  @override
  List<Object> get props => [country,city];
}
