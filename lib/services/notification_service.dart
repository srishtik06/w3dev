import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize timezone package
    tz.initializeTimeZones();

    // Android settings
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();

    // Combine both
    const InitializationSettings settings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> requestPermissions() async {
    // Request permissions for iOS
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Android: Use the newer `requestPermission` method from `FlutterLocalNotificationsPlugin`
    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // if (granted != null && granted) {
    //   print("Notification permission granted!");
    // } else {
    //   print("Notification permission denied!");
    // }
  }

  static Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.scheduleExactAlarm.status;
      // if (status.isGranted) {
      //   print("Exact alarm permission is already granted");
      //   return; // No need to request again
      // }

      // If not granted, redirect to settings
      const AndroidIntent intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    }
  }
  static Future<void> showImmediateNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Immediate Notification',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      0, // Notification ID
      'Immediate Alert',
      'This is an instant notification!',
      platformDetails,
    );
  }


  Future<void> initializeTimezone() async {
    tz.initializeTimeZones();
    final String localTimeZone = DateTime.now().timeZoneName;
    tz.setLocalLocation(tz.getLocation(_convertToTZDatabaseName(localTimeZone)));
  }

// Convert system timezone format to TZ database format
  String _convertToTZDatabaseName(String systemTimezone) {
    Map<String, String> timezoneMap = {
      "IST": "Asia/Kolkata",
      "UTC": "UTC",
      "EST": "America/New_York",
      "PST": "America/Los_Angeles",
    };
    return timezoneMap[systemTimezone] ?? "UTC"; // Default to UTC if unknown
  }


  Future<void> scheduleNotification() async {
    try {
      String currentTimeZone = tz.local.toString(); // Get current timezone
      // print("Current Timezone: $currentTimeZone");

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      // print("Current Local Time: $now");

      final tz.TZDateTime scheduledTime = now.add(Duration(seconds: 5)); // ✅ Correct timezone
      // print("Notification scheduled for: $scheduledTime");

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'channel_id',
        'Scheduled Notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails details = NotificationDetails(android: androidDetails);

      await _notificationsPlugin.zonedSchedule(
        0,
        "Reminder",
        "This is your scheduled notification!",
        scheduledTime,
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

      print("Notification successfully scheduled at $scheduledTime in timezone: $currentTimeZone");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }
}

