import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/splash/view/splash_view.dart';
import 'package:flutter_base_app/feature/home/home_view.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return SplashView();
        },
        routes: <RouteBase>[
          //! Örnek Routelar
          GoRoute(
            path: 'home_view',
            builder: (BuildContext context, GoRouterState state) {
              return HomeView();
            },
          ),
          // GoRoute(
          //   path: 'initial',
          //   builder: (BuildContext context, GoRouterState state) {
          //     return BlocProvider(
          //       create: (context) => RegisterCubit(),
          //       child: InitialView(),
          //     );
          //   },
          // ),
          // GoRoute(
          //   path: 'login',
          //   builder: (BuildContext context, GoRouterState state) {
          //     return BlocProvider(
          //       create: (context) => LoginCubit(),
          //       child: const LoginView(),
          //     );
          //   },
          // ),
          // GoRoute(
          //   path: 'register',
          //   builder: (BuildContext context, GoRouterState state) {
          //     return RegisterView(
          //       license: state.extra as LicenseModel?,
          //     );
          //   },
          // ),
          // GoRoute(
          //   path: 'store',
          //   builder: (BuildContext context, GoRouterState state) {
          //     return BlocProvider.value(
          //       value: (state.extra as Map<String, dynamic>)['storeCubit']
          //           as StoreCubit,
          //       child: StoreView(
          //         // packageId: (state.extra as Map<String, dynamic>)['packageId'] as int,
          //         // isBackButtonVisible: (state.extra as Map<String, dynamic>)['isBackButtonVisible'] as bool,
          //         pageType:
          //             (state.extra as Map<String, dynamic>)['pageType'] as int,
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    ],
  );
}
