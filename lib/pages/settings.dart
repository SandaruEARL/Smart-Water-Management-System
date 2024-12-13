import 'package:aqua/pages/Navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isNotificationEnabled = false;
  bool isDashboardDisabled = false;
  late DatabaseReference notificationRef;

  @override
  void initState() {
    super.initState();
    _initializeNotification();
    _loadSettings();
    _setupFirebaseListener();
  }

  Future<void> _initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Ensure this icon exists

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationEnabled = prefs.getBool('isNotificationEnabled') ?? false;

    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationEnabled', isNotificationEnabled);
    await prefs.setBool('isDashboardDisabled', isDashboardDisabled);
  }

  void _setupFirebaseListener() {
    notificationRef = FirebaseDatabase.instance.ref('autopower'); // Path to the notification field

    notificationRef.onValue.listen((event) {
      final bool? notificationEnabled = event.snapshot.value as bool?;

      if (notificationEnabled == true && isNotificationEnabled) {
        _showNotification();
      }
    });
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'Quota_noti', // Define your channel ID
      'Water_quota_excedence_notification', // Define your channel name
      channelDescription: 'Notification_will_occur_when_limit_is_exceeds', // Define your channel description
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Supply is closed now',
      'Your allocated Quota is over!., ',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(onPressed: () { Get.offAll(const MyNavigationBar()); }),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(color: Colors.white, height: 0,),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.grey])
          ),
        ),
        centerTitle: false,
        title: const Text("Settings", style: TextStyle(fontFamily: "roboto", color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Text("Notification", style: TextStyle(fontFamily: "kinetika", fontSize: 19, color: Colors.grey)),
                const SizedBox(width: 125),
                Switch(
                  activeColor: Colors.green,
                  activeTrackColor: Colors.green.shade300,
                  inactiveThumbColor: Colors.blueGrey.shade600,
                  inactiveTrackColor: Colors.grey.shade400,
                  value: isNotificationEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      isNotificationEnabled = value;
                      _saveSettings(); // Save state on change
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
