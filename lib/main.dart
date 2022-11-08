import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

void main(){

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences localStorage;

  late FirebaseMessaging _fcm;
  @override
  void initState() {
    Firebase.initializeApp().then((value) async {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
      FirebaseMessaging.instance.getToken().then((value) async{
      //  FirebaseMessaging.instance.subscribeToTopic('bridgeport_notification');
        var device_id=await _getId();
        save(value, device_id);
      });
    });
  }
  Future<String?> _getId() async {

    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }

  }

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
  save(fcm_token,device_id) async {

    SharedPreferences.getInstance().then((value){
      value.setString("fcm_id", fcm_token);
      value.setString("device_id", device_id);
    });
  }
}

