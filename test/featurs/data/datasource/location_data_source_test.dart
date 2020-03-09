import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:pray/features/data/data_source/location_data_source.dart';
import 'package:pray/features/data/model/location_model.dart';
import 'package:pray/features/domain/entity/location_entity.dart';

class GeoLocatorMock extends Mock implements Geolocator{}

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();

  Geolocator geoLocatorMock;
  LocationDataSource locationDataSource;
  setUp((){
    geoLocatorMock = GeoLocatorMock();
    locationDataSource = LocationDataSourceImpl(geoLocator: geoLocatorMock);

  });


  test("should return Device Location", () async{
    final expected = DeviceLocationModel(
      latitude: 1.1,
      longitude: 1.2,
    );
    when(geoLocatorMock.getCurrentPosition(desiredAccuracy: anyNamed('desiredAccuracy')))
    .thenAnswer((_)=>Future.value(expected.toPosition()));

    final actual = await locationDataSource.getCurrentLocation();

    expect(actual, expected);
  });



}