import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/screens/create_user_screen.dart';
import 'package:recuerda_facil/screens/home_screen.dart';
import 'package:recuerda_facil/screens/login_screen.dart';
import 'package:recuerda_facil/screens/settings_screen.dart';
import 'package:recuerda_facil/screens/shared_notes.dart';

final GoRouter appRouter = GoRouter(

  routes: <RouteBase>[
    GoRoute(
      // name: ButtonsScreen.name,
      path: '/',
      builder: ( context,state)=>const  LoginScreen()
    ),
    GoRoute(
      // name: HomeScreen.name,
      path: '/home',
      builder: ( context,state)=>HomeScreen()
    ),

    GoRoute(
      // name: CardsScreen.name,
      path: '/createUser',
      builder: ( context,state)=>const  CreateUserScreen()
    ),
    GoRoute(
      // name: CardsScreen.name,
      path: '/settings',
      builder: ( context,state)=>const  SettingsScreen()
    ),
    GoRoute(
      // name: CardsScreen.name,
      path: '/shared',
      builder: ( context,state)=>const  SharedNotesScreen()
    ),
  ],
);
