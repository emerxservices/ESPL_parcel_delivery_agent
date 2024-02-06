import 'package:espl_parcel_driver/app/modules/home/controllers/home_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../utilities/session_manager.dart';

class PushNotification {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = DarwinInitializationSettings();
    var initSetttings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onDidReceiveNotificationResponse: (payload) async {
      try {
        if (payload != null) {
          // This function handles the click in the notification when the app is in foreground
          print(payload);
        }
      } catch (e) {
        print(e);
      }
    });
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('========= ON MESSAGE =======');
      print(
          'title : ${message.notification?.title}, body: ${message.notification?.body}');
      if (await SessionManager().getBoolean(SessionManager.isLogin) == true) {
        HomeController homeController = Get.find();
        if (message.data['status'] != null) {
          if (message.data['status'] == '2') {
            homeController.resetBooking();
          } else if (message.data['status'] == '6') {
            homeController.locationSubscription?.cancel();
            Get.offAllNamed(Routes.ALL_ORDERS);
          }
        }
        print("Notification msg status : ${message.data['status']}");
      }
      // HANDLE ROUTING HERE,
      PushNotification.showNotification(
          message, flutterLocalNotificationsPlugin);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //App in background
      print('========= ON MESSAGE OPENED FROM BACKGROUND =======');
      print(
          'title : ${message.notification?.title}, body: ${message.notification?.body}');
      try {
        //Handle routing here according to condition
      } catch (e) {
        print(e);
      }
    });
  }

  static Future<void> showNotification(
      RemoteMessage msg, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      msg.notification!.body!,
      htmlFormatBigText: true,
      contentTitle: msg.notification!.title!,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails("channel_id_2", "LFR_Customer",
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            styleInformation: bigTextStyleInformation);

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    await fln.show(0, msg.notification!.title!, msg.notification!.body!,
        platformChannelSpecifics);
  }
}
