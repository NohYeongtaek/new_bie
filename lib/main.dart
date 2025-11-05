import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/src/screens/auth/auth_view_model.dart';
import 'package:new_bie/src/screens/auth/login/login_page.dart';
import 'package:new_bie/src/screens/auth/login/login_view_model.dart';
import 'package:new_bie/src/screens/auth/unregister/unregister_page.dart';
import 'package:new_bie/src/screens/home/home_screen.dart';
import 'package:new_bie/src/screens/home/home_view_model.dart';
import 'package:new_bie/src/screens/journal/journal_page.dart';
import 'package:new_bie/src/screens/my_profile/follow_list/follow_list_page.dart';
import 'package:new_bie/src/screens/my_profile/follow_list/follow_list_view_model.dart';
import 'package:new_bie/src/screens/my_profile/my_profile_page.dart';
import 'package:new_bie/src/screens/my_profile/my_profile_view_model.dart';
import 'package:new_bie/src/screens/my_profile/set_profile_page.dart';
import 'package:new_bie/src/screens/my_profile/set_profile_view_model.dart';
import 'package:new_bie/src/screens/post/post_add_page.dart';
import 'package:new_bie/src/screens/post/post_detail_page.dart';
import 'package:new_bie/src/screens/post/post_edit_page.dart';
import 'package:new_bie/src/screens/post/post_repository.dart';
import 'package:new_bie/src/screens/search/search_result_view_model.dart';
import 'package:new_bie/src/screens/setting/blocked_user/blocked_user_page.dart';
import 'package:new_bie/src/screens/setting/blocked_user/blocked_user_view_model.dart';
import 'package:new_bie/src/screens/setting/notice/notice_detail_page.dart';
import 'package:new_bie/src/screens/setting/notice/notices_page.dart';
import 'package:new_bie/src/screens/setting/notice/notices_repository.dart';
import 'package:new_bie/src/screens/setting/notice/notices_view_model.dart';
import 'package:new_bie/src/screens/setting/question/question_page.dart';
import 'package:new_bie/src/screens/splash_page.dart';
import 'package:new_bie/src/screens/user_profile/user_profile_page.dart';
import 'package:new_bie/src/ui_set/colors.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bottom_nav_bar.dart';

EventBus eventBus = EventBus();

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://syfgficcejjgtvpmtkzx.supabase.co',
    anonKey: // 인증키
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return AuthViewModel();
          },
        ),
        Provider(create: (context) => PostRepository()),
        Provider(create: (context) => NoticesRepository()),
        ChangeNotifierProvider(
          create: (context) {
            return NoticesViewModel(context);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return LoginViewModel(context);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return HomeViewModel(context.read<PostRepository>());
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return FollowListViewModel(context);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return MyProfileViewModel(context);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return SetProfileViewModel(context);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return SearchResultViewModel(context);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return BlockedUserViewModel(context);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String title;

  // 생성자
  const MyApp({super.key, this.title = "타이틀"});

  // 오버라이드 -
  @override
  Widget build(BuildContext context) {
    // final AuthViewModel authVM = context.read<AuthViewModel>();

    // 1. authVM - 데이터 상태를 바꾼다
    // 2. 고 라우터 refreshListenable 에 authVM 이 연동되어 있다.
    // 3. authVM 의 데이터 변수가 바뀌면
    // 4. 고라우터의 redirect 로직이 타게된다.
    // 5. 현재 사용자 인증 상태는 authVM 로 알 수 있다.
    // 6. GoRouterState는 현재 사용자가 머물고 있는 화면 라우팅 주소를 알고 있다.
    // 7. 우리의 입맛에 맞게 화면이동처리가 가능하다.

    // final repo = context.read<MemoRepository>();

    // 라우트 설정
    final _router = GoRouter(
      initialLocation: '/home',
      // refreshListenable: authVM,
      // redirect: (BuildContext context, GoRouterState state) {
      //   final bool isLoggedIn = authVM.isLoggedIn;
      //   debugPrint("[리디렉트] isLoggedIn: ${isLoggedIn}");
      //   final String currentRoute = state.uri.toString();
      //   debugPrint("[리디렉트] currentRoute: ${currentRoute}");
      //
      //   if (isLoggedIn && currentRoute == '/login') {
      //     return '/home';
      //   }
      //   Set<String> unAuthenticatedRoutes = {'/login', '/register'};
      //   if (!isLoggedIn && !unAuthenticatedRoutes.contains(currentRoute)) {
      //     return '/login';
      //   }
      //
      //   return null;
      // },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: '/splash',
          builder: (context, state) {
            return const SplashPage();
          },
        ),
        GoRoute(
          path: '/unregister',
          builder: (context, state) {
            return const UnregisterPage();
          },
        ),
        GoRoute(
          path: '/set_profile',
          builder: (context, state) {
            return const SetProfilePage();
          },
        ),
        GoRoute(
          path: '/post/:id',
          builder: (context, state) {
            final postId = state.pathParameters["id"] ?? "0";
            final int detailId = int.parse(postId);
            return const PostDetailPage();
          },
          routes: [
            GoRoute(
              path: '/edit',
              builder: (context, state) {
                return const PostEditPage();
              },
            ),
          ],
        ),
        GoRoute(
          path: '/user_profile/:user_id',
          builder: (context, state) {
            final userId = state.pathParameters["user_id"] ?? "";
            return const UserProfilePage();
          },
        ),
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(body: child, bottomNavigationBar: BottomNavBar());
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) {
                return const HomeScreen();
              },
            ),
            GoRoute(
              path: '/add',
              builder: (context, state) {
                return const PostAddPage();
              },
            ),
            GoRoute(
              path: '/journal',
              builder: (context, state) {
                return const JournalPage();
              },
            ),
            GoRoute(
              path: '/my_profile',
              builder: (context, state) {
                return const MyProfilePage();
              },
              routes: [
                GoRoute(
                  path: '/setting',
                  builder: (context, state) {
                    return const SetProfilePage();
                  },
                  routes: [
                    GoRoute(
                      path: '/question',
                      builder: (context, state) {
                        return const QuestionPage();
                      },
                    ),
                    GoRoute(
                      path: '/notice',
                      builder: (context, state) {
                        return const NoticesPage();
                      },
                      routes: [
                        GoRoute(
                          path: '/:notice_id',
                          builder: (context, state) {
                            final noticeId =
                                state.pathParameters["notice_id"] ?? "0";
                            final int detailId = int.parse(noticeId);
                            return NoticeDetailPage();
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      path: '/blocked_users',
                      builder: (context, state) {
                        return const BlockedUserPage();
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: '/follow',
                  builder: (context, state) {
                    return const FollowListPage();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: orangeColor),
        scaffoldBackgroundColor: blackColor,
        textTheme: ThemeData(
          brightness: Brightness.dark,
        ).textTheme.apply(bodyColor: orangeColor, displayColor: orangeColor),
        iconTheme: const IconThemeData(color: orangeColor),
        appBarTheme: AppBarTheme(
          backgroundColor: blackColor,
          foregroundColor: orangeColor,
        ),
      ),
      routerConfig: _router,
    );
  }
}
