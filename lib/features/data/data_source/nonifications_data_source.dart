import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pray/features/domain/entity/azan_alarm.dart';

abstract class NotificationDataSource{
  Future<bool> setNotifications({@required List<AzanAlarm> notifications});

}

class NotificationDataSourceImpl extends NotificationDataSource{
  final FlutterLocalNotificationsPlugin notificationPlugin;
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings;

  NotificationDataSourceImpl({@required this.notificationPlugin}){
    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

  }
  Future onSelectNotification(String payload) async {
    debugPrint("Notification selected with Payload $payload");
  }



  @override
  Future<bool> setNotifications({List<AzanAlarm> notifications}) async{
    notificationPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
    //notifications.forEach((notification)=>  _scheduleNotification(notification.azanDateTime));
    for(int i = 0;i<notifications.length;i++){
      _scheduleNotification(notifications[i].azanDateTime, i);
    }
    final p = await notificationPlugin.pendingNotificationRequests();
    p.forEach((f)=>print("id = ${f.id}"));
    return true;
  }

  Future<void> _scheduleNotification(
      DateTime azanScheduleTime,
      int id,
      ) async {
    print("Notification scheduled on $azanScheduleTime");
    var scheduledNotificationDateTime =
    azanScheduleTime;
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        //icon: 'secondary_icon',
        sound: 'azan',
        //largeIcon: 'sample_large_icon',
        //largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        //enableLights: true,
        //color:  const Color.fromARGB(255, 255, 0, 0),
        //ledColor: const Color.fromARGB(255, 255, 0, 0),
        //ledOnMs: 1000,
        //ledOffMs: 500
        );
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'azan.aiff',presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

}
