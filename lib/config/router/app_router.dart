import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/screens/login/login_2.dart';
import 'package:recuerda_facil/presentations/screens/screens.dart';

final GoRouter appRouter = GoRouter(

  routes: <RouteBase>[
    GoRoute(
      name: LoginScreen.name,
      path: '/',
      builder: ( context,state)=>const  Login2Screen()
    ),
    GoRoute(
      name: HomeScreen.name,
      path: '/home',
      builder: ( context,state)=>HomeScreen()
    ),

    GoRoute(
      name: CreateUserScreen.name,
      path: '/createUser',
      builder: ( context,state)=>const  CreateUserScreen()
    ),
    GoRoute(
      name: SettingsScreen.name,
      path: '/settings',
      builder: ( context,state)=>const  SettingsScreen()
    ),
    GoRoute(
      name: SharedNotesScreen.name,
      path: '/shared',
      builder: ( context,state)=>const  SharedNotesScreen()
    ),
    GoRoute(
      name: TestScreen.name,
      path: '/test',
      builder: ( context,state)=>const  TestScreen()
    ),
    GoRoute(
      name: CalendarScreen.name,
      path: '/calendar',
      builder: ( context,state)=>const  CalendarScreen()
    ),
    GoRoute(
      name: MoreScreen.name,
      path: '/more',
      builder: ( context,state)=>const  MoreScreen()
    ),
    GoRoute(
      name: AccountScreen.name,
      path: '/account',
      builder: ( context,state)=>const  AccountScreen()
    ),
     GoRoute(
      name: UsersGuideScreen.name,
      path: '/user_guide',
      builder: ( context,state)=>const  UsersGuideScreen()
    ),
    GoRoute(
      name: PrivacyScreen.name,
      path: '/privacy',
      builder: ( context,state)=>const  PrivacyScreen()
    ),
    GoRoute(
      name: SupportScreen.name,
      path: '/support',
      builder: ( context,state)=>const  SupportScreen(),
      routes: [
        GoRoute(
          name: ContactInfoScreen.name,
          path:'contact_info',
        builder: ( context,state)=>const  ContactInfoScreen()
         ),
         GoRoute(
          name: FAQScreen.name,
          path:'faq',
        builder: ( context,state)=>const  FAQScreen()
         ),
         GoRoute(
          name: CommentsScreen.name,
          path:'comments',
        builder: ( context,state)=>const  CommentsScreen()
         ),

      ],
    ),
    GoRoute(
      name: AboutScreen.name,
      path: '/about',
      builder: ( context,state)=>const  AboutScreen()
    ),
    GoRoute(
      name: CommunityScreen.name,
      path: '/community',
      builder: ( context,state)=>const  CommunityScreen()
    ),
    GoRoute(
      name: AppearanceScreen.name,
      path: '/appearance',
      builder: ( context,state)=>const  AppearanceScreen()
    ),
  ],
);
