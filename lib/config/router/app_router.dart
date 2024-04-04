import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/features/auth/presentation/screens/screens.dart';
import 'package:recuerda_facil/presentations/screens/more/more_games/games/tictac/tictactoe_game.dart';
import 'package:recuerda_facil/presentations/screens/more_functions/carer/carer_list.dart';
import 'package:recuerda_facil/presentations/screens/screens.dart';
import 'package:recuerda_facil/presentations/screens/test/alarm.dart';
import 'package:recuerda_facil/presentations/views/notes/more_view.dart';

import '../../features/auth/presentation/providers/providers_auth.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  return GoRouter(
    initialLocation: '/splashScreen',
    refreshListenable: goRouterNotifier,
    routes: [
      //pantallas
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
          name: ForgetPasswordScreen.name,
          path: '/forgetPassword',
          builder: (context, state) => const ForgetPasswordScreen()),
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
                    builder: (context, state) => const TicTacToeScreen()),
              ]),
          GoRoute(
              name: BoardScreen.name,
              path: 'boards',
              builder: (context, state) => const BoardScreen(),
              routes: [
                GoRoute(
                    name: BoardsSCreen.name,
                    path: 'boards_list',
                    builder: (context, state) => const BoardsSCreen(),
                    routes: [
                      GoRoute(
                          name: BoardChatScreen.name,
                          path: 'board/:boardId',
                          builder: (context, state) {
                            final boardId =
                                state.pathParameters['boardId'] ?? '0';
                            return BoardChatScreen(boardId: boardId);
                          }),
                    ]),
              ]),
          GoRoute(
              name: ProductivityScreen.name,
              path: 'productivity',
              builder: (context, state) => const ProductivityScreen()),
          GoRoute(
              name: ChatsScreen.name,
              path: 'chats',
              builder: (context, state) => const ChatsScreen(),
              routes: [
                GoRoute(
                    name: ChatScreen.name,
                    path: 'chat/:chatId',
                    builder: (context, state) {
                      final chatId = state.pathParameters['chatId'] ?? '0';
                      return ChatScreen(
                        chatId: chatId,
                      );
                    }),
              ]),
        ],
      ),
      GoRoute(
          name: AccountScreen.name,
          path: '/account',
          builder: (context, state) => const AccountScreen()),
      GoRoute(
          name: UsersGuideFirstInitScreen.name,
          path: '/user_guide_first_init',
          builder: (context, state) => const UsersGuideFirstInitScreen()),
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
          name: ScreenBackground.name,
          path: '/background',
          builder: (context, state) => const ScreenBackground()),
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
          builder: (context, state) => const SplashScreen()),
      GoRoute(
          name: FirstSignInScreen.name,
          path: '/firstSignIn',
          builder: (context, state) => FirstSignInScreen()),
      GoRoute(
          name: EmailVerifiedScreen.name,
          path: '/emailVerified',
          builder: (context, state) => const EmailVerifiedScreen())
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;
      // if (authStatus == AuthStatus.checking) return '/splashScreen';
      if (isGoingTo == '/login' && authStatus == AuthStatus.firstSignIn) {
        return '/firstSignIn';
      }
      if (isGoingTo == '/login' && authStatus == AuthStatus.emailVerified) {
        return '/emailVerified';
      }
      if (isGoingTo == '/emailVerified' &&
          authStatus == AuthStatus.firstSignIn) {
        return '/firstSignIn';
      }
      if (isGoingTo == '/splashScreen' && authStatus == AuthStatus.firstInit) {
        return '/user_guide_first_init';
      }
      if (isGoingTo == '/firstSignIn' &&
          authStatus == AuthStatus.authenticated) {
        return '/home/1';
      }
      if (isGoingTo == '/splashScreen' &&
          authStatus == AuthStatus.authenticated) return '/home/1';
      if (isGoingTo == '/createUser' &&
          authStatus == AuthStatus.notAuthenticated) return '/createUser';
      if (isGoingTo == '/forgetPassword' &&
          authStatus == AuthStatus.notAuthenticated) return '/forgetPassword';

      if (isGoingTo == '/login' && authStatus == AuthStatus.authenticated) {
        return '/home/1';
      } else if (isGoingTo != '/login' &&
          authStatus == AuthStatus.notAuthenticated) {
        return '/login';
      }

      return null;
    },
  );
});
