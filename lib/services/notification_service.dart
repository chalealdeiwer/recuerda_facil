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
    1,
    'Agrega Recordatorios 😄 ',
    'Planea tu día con Recuerda Fácil🌞',
    notificationDetails,
  );
}

Future<void> showNotificationWithImage() async {
  var bigPictureStyleInformation = const BigPictureStyleInformation(
    DrawableResourceAndroidBitmap('/assets/images/users_guide/planDay.png'),   // Reemplaza 'app_icon' con el nombre de tu asset
    largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    contentTitle: 'Notificación con imagen',
    htmlFormatContentTitle: true,
    summaryText: 'Resumen',
    htmlFormatSummaryText: true,
  );

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'bigPictureChannelId',
    'bigPictureNotifications',
    styleInformation: bigPictureStyleInformation,
  );

  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    3,
    'Notificación con imagen',
    'Muestra una notificación con imagen',
    platformChannelSpecifics,
  );
}
Future<void> showNotification2(String content) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    // actions: <AndroidNotificationAction>[
    //   // AndroidNotificationAction('id_1', 'Cerrar✖️'),
    
    // ],
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    // ongoing: true, // Esto hace que la notificación sea persistente

  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Ha llegado la hora de recordar.⌚⌚',
    content,
    notificationDetails,
  );
}


