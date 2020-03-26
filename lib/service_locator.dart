import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pray/features/data/data_source/local_data_source.dart';
import 'package:pray/features/data/data_source/location_data_source.dart';
import 'package:pray/features/data/data_source/remote_data_source.dart';
import 'package:pray/features/domain/repository/calender_month_reepository.dart';
import 'package:pray/features/presentation/bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'features/data/data_source/nonifications_data_source.dart';
import 'features/data/repository/calender_month_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async{

  final prefs = await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>( prefs);
  sl.registerSingleton<http.Client>( http.Client());
  //bloc
  sl.registerFactory(()=>DayTimings(repository: sl()));


  sl.registerSingleton<LocalDataSource>(LocalDataSourceImpl(preferences: sl()));
  sl.registerSingleton<RemoteDataSource>(RemoteDataSourceImpl(client: sl()));
  sl.registerSingleton<Geolocator>( Geolocator());
  sl.registerSingleton<PermissionHandler>(PermissionHandler());
  sl.registerSingleton<LocationDataSource>(LocationDataSourceImpl(geoLocator: sl(),permissionHandler: sl()));
  sl.registerSingleton<FlutterLocalNotificationsPlugin>(FlutterLocalNotificationsPlugin());
  sl.registerSingleton<NotificationDataSource>(NotificationDataSourceImpl(notificationPlugin: sl()));

  sl.registerSingleton<CalenderMonthRepository>(CalenderMonthRepositoryImpl(
    local: sl(),
    remote: sl(),
    location: sl(),
    notificationsDataSource: sl(),

  ));

}