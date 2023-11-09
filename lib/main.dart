import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
import 'package:recuerda_facil/config/theme/app_theme.dart';
import 'package:recuerda_facil/config/router/app_router.dart';
import 'package:recuerda_facil/firebase_options.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:recuerda_facil/presentations/providers/theme_provider.dart';
import 'package:recuerda_facil/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';


void main() async {
  await initializeDateFormatting('es_ES', null);
  Intl.defaultLocale = 'es_ES';

  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  await AndroidAlarmManager.initialize();

  runApp(
    const ProviderScope(child:  MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final AppTheme appTheme= ref.watch(themeNotifierProvider);

    final FlutterLocalization localization = FlutterLocalization.instance;
    return MaterialApp.router(
      routerConfig: appRouter,

      localizationsDelegates: localization.localizationsDelegates,

      supportedLocales: const [
        Locale('es', 'ES'), // Español
      ],
      locale: const Locale('es', 'ES'),

      title: 'Material App',
      //custom theme
      theme: appTheme.getTheme(),

    

      debugShowCheckedModeBanner: false,
    );
  }
}
