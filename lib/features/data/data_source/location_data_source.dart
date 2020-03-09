import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pray/features/data/model/location_model.dart';
import 'package:pray/features/domain/entity/location_entity.dart';
import 'package:permission_handler/permission_handler.dart';


abstract class LocationDataSource{

  Future<DeviceLocation> getCurrentLocation();
  Future<DevicePlaceMark> getCurrentPlaceMark();
  Future<DevicePlaceMark> getPlaceMarkFromPosition({@required DeviceLocation location});

}

class LocationDataSourceImpl implements LocationDataSource{

  final Geolocator geoLocator;

  LocationDataSourceImpl({@required this.geoLocator});

  @override
  Future<DeviceLocation> getCurrentLocation() async{
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    debugPrint("geolocation status is ${geolocationStatus.value} ");
    if(geolocationStatus == null){
      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
    }
    if(geolocationStatus == GeolocationStatus.granted){
      final position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return DeviceLocationModel.fromPosition(position);
    }

    final testPosition = DeviceLocation(
      longitude: 29.898887,
      latitude: 31.199988,
    );
    //ToDo replace with user preferences / settings.
    return testPosition;
  }

  @override
  Future<DevicePlaceMark> getCurrentPlaceMark() async{

    final currentDevicePosition = await getCurrentLocation();
    return getPlaceMarkFromPosition(location: currentDevicePosition);
//    final placeMarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
//    final devicePlaceMark = DevicePlaceMarkModel.fromPlaceMark(placeMarks[0]);
//    return devicePlaceMark;
  }

  @override
  Future<DevicePlaceMark> getPlaceMarkFromPosition({DeviceLocation location}) async{
    final placeMarks = await Geolocator().placemarkFromCoordinates(location.latitude, location.longitude);
    final placeMark = DevicePlaceMarkModel.fromPlaceMark(placeMarks[0]);
    return placeMark;
  }


}