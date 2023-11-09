import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/screens/login/login_2.dart';
import 'package:recuerda_facil/presentations/screens/more/more_games/games/tictac/tictactoe_game.dart';
import 'package:recuerda_facil/presentations/screens/more_functions/carer/carer_list.dart';
import 'package:recuerda_facil/presentations/screens/screens.dart';
import 'package:recuerda_facil/presentations/screens/test/alarm.dart';
import 'package:recuerda_facil/presentations/views/notes/more_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splashScreen',
  routes: [
    GoRoute(
        name: HomeScreen.name,
        path: '/home/:page',
        builder: (context, state) {
          final pageIndex = state.pathParameters['page'] ?? '0';
          return HomeScreen(
            pageIndex: int.parse(pageIndex),
          );
        }),
    GoRoute(path: '/', redirect: (_, __) => '/home/1'),
    GoRoute(
        name: LoginScreen.name,
        path: '/login',
        builder: (context, state) => const Login2Screen()),
    GoRoute(
        name: CreateUserScreen.name,
        path: '/createUser',
        builder: (context, state) => const CreateUserScreen()),
    GoRoute(
        name: SettingsScreen.name,
        path: '/settings',
        builder: (context, state) => const SettingsScreen()),
    GoRoute(
        name: SharedNotesScreen.name,
        path: '/shared',
        builder: (context, state) => const SharedNotesScreen()),
    GoRoute(
        name: TestScreen.name,
        path: '/test',
        builder: (context, state) => const AlarmTest()),
    GoRoute(
        name: CalendarScreen.name,
        path: '/calendar',
        builder: (context, state) => const CalendarScreen()),
    GoRoute(
      path: '/more',
      builder: (context, state) => const MoreView(),
      routes: [
        GoRoute(
            name: NewsScreen.name,
            path: 'news',
            builder: (context, state) => const NewsScreen()),
        GoRoute(
            name: GamesScreen.name,
            path: 'games',
            builder: (context, state) => const GamesScreen(),
            routes: [
              GoRoute(
                  name: TicTacToeScreen.name,
                  path: 'tic_tac_toe',
                  builder: (context, state) =>  TicTacToeScreen()),
            ]),
        GoRoute(
            name: BoardScreen.name,
            path: 'boards',
            builder: (context, state) => const BoardScreen()),
        GoRoute(
            name: ProductivityScreen.name,
            path: 'productivity',
            builder: (context, state) => const ProductivityScreen()),
      ],
    ),
    GoRoute(
        name: AccountScreen.name,
        path: '/account',
        builder: (context, state) => const AccountScreen()),
    GoRoute(
        name: UsersGuideScreen.name,
        path: '/user_guide',
        builder: (context, state) => const UsersGuideScreen()),
    GoRoute(
        name: PrivacyScreen.name,
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen()),
    GoRoute(
      name: SupportScreen.name,
      path: '/support',
      builder: (context, state) => const SupportScreen(),
      routes: [
        GoRoute(
            name: ContactInfoScreen.name,
            path: 'contact_info',
            builder: (context, state) => const ContactInfoScreen()),
        GoRoute(
            name: FAQScreen.name,
            path: 'faq',
            builder: (context, state) => const FAQScreen()),
        GoRoute(
            name: CommentsScreen.name,
            path: 'comments',
            builder: (context, state) => const CommentsScreen()),
      ],
    ),
    GoRoute(
        name: AboutScreen.name,
        path: '/about',
        builder: (context, state) => const AboutScreen()),
    GoRoute(
        name: CommunityScreen.name,
        path: '/community',
        builder: (context, state) => const CommunityScreen()),
    GoRoute(
        name: AppearanceScreen.name,
        path: '/appearance',
        builder: (context, state) => const AppearanceScreen()),
    GoRoute(
        name: MoreFunctionsScreen.name,
        path: '/more_functions',
        builder: (context, state) => const MoreFunctionsScreen()),
    GoRoute(
        name: CarerScreen.name,
        path: '/carer',
        builder: (context, state) => const CarerScreen()),
    GoRoute(
        name: CarerListStream.name,
        path: '/carer_list/:user',
        builder: (context, state) {
          final user = state.pathParameters['user'] ?? '0';
          return CarerListStream(category: 'Todos', user: user);
        }),
    GoRoute(
        name: SetCarer.name,
        path: '/set_carer',
        builder: (context, state) => const SetCarer()),
    GoRoute(
        name: AddPersonCareScreen.name,
        path: '/add_person_care',
        builder: (context, state) => const AddPersonCareScreen()),
    GoRoute(
        name: SplashScreen.name,
        path: '/splashScreen',
        builder: (context, state) => SplashScreen(
              loading: true,
            )),
  ],
);
