import 'package:fixnow/config/router/app_router_notifier.dart';
import 'package:fixnow/presentation/providers/auth/auth_provider.dart';
import 'package:fixnow/presentation/screens.dart';
import 'package:fixnow/presentation/screens/supplier/chat_supplier.dart';
import 'package:fixnow/presentation/screens/supplier/configure_profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterUserScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/activate',
        builder: (context, state) => const ActivateScreen(),
      ),
      GoRoute(
        path: '/home/:page',
        builder: (context, state) {
          final pageIndex =
              state.pathParameters['page'] ?? '0'; 
          return HomeScreen(pageIndex: int.parse(pageIndex));
        },
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) => ChatScreen(
          supplierId: state.pathParameters['id'] ?? 'no-id',
        ),
      ),
      GoRoute(
        path: '/chat/customer/:id/:name',
        builder: (context, state) => ChatSupplier(
          customerId: state.pathParameters['id'] ?? 'no-id',
          name: state.pathParameters['name'] ?? 'no-name',
        ),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/details-service/:id',
        builder: (context, state) => DetailsNotifications(
          serviceId: state.pathParameters['id'] ?? 'no-id',
        ),
      ),
      GoRoute(
          path: '/schedule/:id',
          builder: (context, state) => ScheduleService(
                supplierId: state.pathParameters['id'] ?? 'no-id',
              )),
      GoRoute(
          path: '/user/select',
          builder: (context, state) => const UserSelect()),
      GoRoute(
        path: '/supplier/:id',
        builder: (context, state) => ProfileSuplier(
          supplierId: state.pathParameters['id'] ?? 'no-id',
        ),
      ),
      GoRoute(
        path: '/schedule/2/:id',
        builder: (context, state) => ScheduleServiceTwo(
            supplierId: state.pathParameters['id'] ?? 'no-id'),
      ),
      GoRoute(
        path: '/configure/information',
        builder: (context, state) => const ConfigureProfileScreen(),
      ),
      GoRoute(
          path: '/edit/profile',
          builder: (context, state) => const EditProfileScreen()),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;
      final user = goRouterNotifier.user;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/user/select') return null;

        return '/';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/' ||
            isGoingTo == '/splash') {
          return '/home/0';
        }
      }

      if (authStatus == AuthStatus.newUserRegistred) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/') {
          return '/activate';
        }
      }

      if (authStatus == AuthStatus.accountActivated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/' ||
            isGoingTo == '/activate') {
          if (user != null && user.role == 'SUPPLIER') {
            return '/configure/information';
          }

          return '/home/0';
        }
      }

      return null;
    },
  );
});
