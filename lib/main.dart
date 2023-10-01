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
import 'package:velocity_x/velocity_x.dart';

void main() async {
  await initializeDateFormatting('es_ES', null);
  Intl.defaultLocale = 'es_ES';

  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

      // ThemeData(
      //   useMaterial3: true,
      //   colorScheme: const ColorScheme(brightness: Brightness.light,
      //    primary: Color.fromARGB(255, 35, 132, 55),
      //     onPrimary: Color.fromARGB(255, 23, 23, 23),
      //     secondary: Color.fromARGB(255, 10, 206, 128),
      //     onSecondary: Color.fromARGB(255, 36, 21, 247),
      //      error: Color.fromARGB(255, 255, 0, 0),
      //       onError: Color.fromARGB(255, 52, 58, 38),
      //        background: Color(0xFFE8EDDB),
      //         onBackground: Color.fromARGB(255, 57, 57, 57),
      //          surface: Color(0xFFE8EDDB),
      //           onSurface: Color.fromARGB(255, 13, 13, 13)),

      // ),

      debugShowCheckedModeBanner: false,
    );
  }
}
