import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pray/core/exeptions.dart';
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
  final PermissionHandler permissionHandler;

  LocationDataSourceImpl({@required this.geoLocator,@required this.permissionHandler});

  GeolocationStatus getGeoFromPermission(PermissionStatus status){
    switch (status){
      case PermissionStatus.granted:
        return GeolocationStatus.granted;
      case PermissionStatus.denied:
        return GeolocationStatus.denied;
      case PermissionStatus.restricted:
        return GeolocationStatus.restricted;
      default:
        return GeolocationStatus.unknown;

    }
  }

  @override
  Future<DeviceLocation> getCurrentLocation() async{
    GeolocationStatus geolocationStatus  = await geoLocator.checkGeolocationPermissionStatus();
    if(geolocationStatus == null){
      Map<PermissionGroup, PermissionStatus> permissions = await permissionHandler.requestPermissions([PermissionGroup.location]);
      geolocationStatus = getGeoFromPermission (permissions[PermissionGroup.location]);
    }
    if(geolocationStatus == GeolocationStatus.granted){
      final position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return DeviceLocationModel.fromPosition(position);
    }

//    final testPosition = DeviceLocation(
//      longitude: 29.898887,
//      latitude: 31.199988,
//    );
    //ToDo replace with more informative exception.
    //return testPosition;
    throw LocationException();
  }

  @override
  Future<DevicePlaceMark> getCurrentPlaceMark() async{

    final currentDevicePosition = await getCurrentLocation();
    return getPlaceMarkFromPosition(location: currentDevicePosition);
  }

  @override
  Future<DevicePlaceMark> getPlaceMarkFromPosition({DeviceLocation location}) async{
    final placeMarks = await geoLocator.placemarkFromCoordinates(location.latitude, location.longitude);
    final placeMark = DevicePlaceMarkModel.fromPlaceMark(placeMarks[0]);
    return placeMark;
  }


}