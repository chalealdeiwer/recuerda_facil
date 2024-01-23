import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:recuerda_facil/config/router/app_router.dart';
import 'package:recuerda_facil/config/theme/app_theme.dart';
import 'package:recuerda_facil/firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recuerda_facil/presentations/providers/theme_provider.dart';
import 'package:recuerda_facil/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main() async {
  //formato de fechas en español
  await initializeDateFormatting('es_ES');

  Intl.defaultLocale = 'es';

  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await showNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  await AndroidAlarmManager.initialize();

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final AppTheme appTheme = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      
      routerConfig: ref.watch(goRouterProvider),
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],

      supportedLocales: const [
        Locale('es', 'ES'),
        // Locale('en', 'EN') // Español
      ],
      locale: const Locale('es'),
      title: 'Recuerda Fácil',
      //custom theme
      theme: appTheme.getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
