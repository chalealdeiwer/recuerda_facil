import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction('id_1', 'Cerrar✖️'),
      // AndroidNotificationAction('id_2', 'Action 2'),
      // AndroidNotificationAction('id_3', 'Action 3'),
    ],
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    ongoing: true, // Esto hace que la notificación sea persistente

  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Agrega Recordatorios 😄 ',
    'Planea tu día con Recuerda Fácil🌞',
    notificationDetails,
  );
}

Future<void> showStickyNotificationWithActions() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_default_channel_id',
    'your_channel_name',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: true,
    ongoing: true, // Esto hace que la notificación sea persistente
    // Aquí puedes agregar acciones si la versión de la biblioteca las soporta
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Persistent Notification',
    'This notification cannot be dismissed',
    platformChannelSpecifics,
  );
}
