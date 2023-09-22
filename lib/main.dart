import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recuerda_facil/config/app_theme.dart';
import 'package:recuerda_facil/config/router/app_router.dart';
import 'package:recuerda_facil/firebase_options.dart';
import 'package:recuerda_facil/providers/notes_provider.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:velocity_x/velocity_x.dart';

void main() async {
  await initializeDateFormatting('es_ES', null);
  Intl.defaultLocale = 'es_ES';

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
      theme: AppTheme(selectedColor: 6).theme(),

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

      //dart theme
      // theme: ThemeData.dark(
      //   useMaterial3: true
      // ),

      // darkTheme: ThemeData.dark().copyWith(
      //   useMaterial3: true,
      //   // Define el ColorScheme para el modo oscuro
      //   colorScheme: const ColorScheme.dark(
      //     primary: Colors.green, // Cambia el color primario en modo oscuro
      //     // Otras configuraciones de colores en modo oscuro
      //   )),
      debugShowCheckedModeBanner: false,
    );
  }
}
