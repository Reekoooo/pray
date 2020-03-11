import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pray/core/exeptions.dart';
import 'package:pray/features/data/data_source/location_data_source.dart';
import 'package:pray/features/data/model/location_model.dart';

class GeoLocatorMock extends Mock implements Geolocator{}
class PermissionHandlerMock extends Mock implements PermissionHandler {}

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();

  Geolocator geoLocatorMock;
  PermissionHandler permissionHandlerMock;
  LocationDataSource locationDataSource;
  setUp((){
    geoLocatorMock = GeoLocatorMock();
    permissionHandlerMock = PermissionHandlerMock();
    locationDataSource = LocationDataSourceImpl(geoLocator: geoLocatorMock,permissionHandler: permissionHandlerMock);
  });

  group('geolocation status null', (){
    final expected = DeviceLocationModel(
      latitude: 1.1,
      longitude: 1.2,
    );

    setUp((){

      final geoLocationStatus = null;
      when(geoLocatorMock.checkGeolocationPermissionStatus()).thenAnswer((_)=>Future.value(geoLocationStatus));

    });
    test('should request location permission when geolocation status is null', () async{
      final permissionStatus = {PermissionGroup.location:PermissionStatus.granted};

      when(permissionHandlerMock.requestPermissions(any)).thenAnswer((_)=>Future.value(permissionStatus));
      when(geoLocatorMock.getCurrentPosition(desiredAccuracy: anyNamed('desiredAccuracy')))
          .thenAnswer((_)=>Future.value(expected.toPosition()));

      await locationDataSource.getCurrentLocation();
      verify(permissionHandlerMock.requestPermissions([PermissionGroup.location]));
    });

    test("should return Device Location when permission status is granted", () async{

      final permissionStatus = {PermissionGroup.location:PermissionStatus.granted};
      when(permissionHandlerMock.requestPermissions(any)).thenAnswer((_)=>Future.value(permissionStatus));
      when(geoLocatorMock.getCurrentPosition(desiredAccuracy: anyNamed('desiredAccuracy')))
          .thenAnswer((_)=>Future.value(expected.toPosition()));

      final actual = await locationDataSource.getCurrentLocation();

      expect(actual, expected);
    });

    test('should throw exception when permission status is denied', () async{
      final permissionStatus = {PermissionGroup.location:PermissionStatus.denied};

      when(permissionHandlerMock.requestPermissions(any)).thenAnswer((_)=>Future.value(permissionStatus));

      final actual = () =>  locationDataSource.getCurrentLocation();

      expect(actual,throwsA(LocationException()));

    });



  });

  group('geolocation status is not null',(){
    final expected = DeviceLocationModel(
      latitude: 1.1,
      longitude: 1.2,
    );

    setUp((){
      final geoLocationStatus = GeolocationStatus.granted;
      when(geoLocatorMock.checkGeolocationPermissionStatus()).thenAnswer((_)=>Future.value(geoLocationStatus));
    });

    test('should not request location permission when geolocation status is not null', () async{
      when(geoLocatorMock.getCurrentPosition(desiredAccuracy: anyNamed('desiredAccuracy')))
          .thenAnswer((_)=>Future.value(expected.toPosition()));

      await locationDataSource.getCurrentLocation();
      verifyNever(permissionHandlerMock.requestPermissions(any));

    });
  });

}