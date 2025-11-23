// lib/common/notify/notifier.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const ios = DarwinInitializationSettings();
  const settings = InitializationSettings(iOS: ios, android: AndroidInitializationSettings('@mipmap/ic_launcher'));
  await flutterLocalNotificationsPlugin.initialize(settings);
}
