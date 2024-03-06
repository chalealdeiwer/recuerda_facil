import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

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
    '3',
    'Notificación principal',
    importance: Importance.min,
    priority: Priority.min,
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
Future<void> showNotificationNewNote() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '10',
    'Notificación principal',
    importance: Importance.min,
    priority: Priority.min,
    showWhen: true,
    ongoing: true,
    channelShowBadge: false,
    enableVibration: true,
    playSound: true,
    visibility: NotificationVisibility.public,
    actions: [
      AndroidNotificationAction(
        'reply_action',
        'Responder',
        // Reemplaza con el nombre de tu icono
        // Habilita la entrada de texto directamente desde la notificación
        // El identificador 'reply_action' se usará en onSelectNotification
        // para manejar la respuesta del usuario
        // También puedes configurar otras propiedades según tus necesidades
        // Consulta la documentación para más detalles
        
        allowGeneratedReplies: true,
      ),
    ],
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    10,
    'Crea un nuevo recordatorio',
    'Escribe el recordatorio en la notificación',
    notificationDetails,
    payload: 'reply_action',
  );
}


Future<void> showNotificationWithImage() async {
  var bigPictureStyleInformation = const BigPictureStyleInformation(
    DrawableResourceAndroidBitmap(
        '@mipmap/ic_launcher'), // Reemplaza 'app_icon' con el nombre de tu asset
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

Future<void> showNotification2(int id, String title, String content) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('4', 'Recordatorios de eventos',
          importance: Importance.max,
          priority: Priority.max,
          vibrationPattern: Int64List.fromList([500, 200, 500, 200]),
          enableVibration: true,
          playSound: true,
          visibility: NotificationVisibility.public,
          showWhen: true,
          sound: const RawResourceAndroidNotificationSound('notification'),
          
          
          fullScreenIntent: true,
          actions: [
        // AndroidNotificationAction("1", "Actualizar🔄"),
        // const AndroidNotificationAction("1", "Cerrar")
      ]
          // ongoing: true, // Esto hace que la notificación sea persistente

          );
  NotificationDetails notificationDetails =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(

    id,
    title,
    content,
    notificationDetails,
  );
}
