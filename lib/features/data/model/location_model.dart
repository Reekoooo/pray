import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pray/features/domain/entity/location_entity.dart';

class DeviceLocationModel extends DeviceLocation{
  DeviceLocationModel({
    @required double latitude,
    @required double longitude,
  }):super(longitude: longitude,latitude: latitude);

  factory DeviceLocationModel.fromPosition(Position position){
    return DeviceLocationModel(
      longitude: position.longitude,
      latitude: position.latitude,
    );
  }

  Position toPosition(){
    return Position(
      latitude: this.latitude,
      longitude: this.longitude,
      mocked: true,
    );
  }


}

class DevicePlaceMarkModel extends DevicePlaceMark{
  DevicePlaceMarkModel({
    @required String country,
    @required String city,
    @required Position position,
}):super(country:country,city:city);

  factory DevicePlaceMarkModel.fromPlaceMark(Placemark placeMark){
    return DevicePlaceMarkModel(
      city: placeMark.name.split(' ')[0],
      country: placeMark.country,
      position: placeMark.position,
    );

  }

}


