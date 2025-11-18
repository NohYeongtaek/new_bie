import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/core/widgets/bottom_nav_bar.dart';
import 'package:new_bie/core/widgets/splash_page.dart';
import 'package:new_bie/features/auth/ui/login_page.dart';
import 'package:new_bie/features/auth/ui/unregister_page.dart';
import 'package:new_bie/features/auth/viewmodel/auth_view_model.dart';
import 'package:new_bie/features/auth/viewmodel/login_view_model.dart';
import 'package:new_bie/features/block_users/ui/blocked_user_page.dart';
import 'package:new_bie/features/block_users/viewmodel/blocked_user_view_model.dart';
import 'package:new_bie/features/follow/ui/follower_list_page.dart';
import 'package:new_bie/features/follow/viewmodel/follow_list_view_model.dart';
import 'package:new_bie/features/journal/ui/journal_page.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';
import 'package:new_bie/features/post/data/post_repository.dart';
import 'package:new_bie/features/post/ui/home_screen.dart';
import 'package:new_bie/features/post/ui/post_add_page.dart';
import 'package:new_bie/features/post/ui/post_detail_page.dart';
import 'package:new_bie/features/post/ui/post_edit_page.dart';
import 'package:new_bie/features/post/ui/search/search_result_page.dart';
import 'package:new_bie/features/post/viewmodel/home_view_model.dart';
import 'package:new_bie/features/post/viewmodel/search/search_result_view_model.dart';
import 'package:new_bie/features/profile/data/notices_repository.dart';
import 'package:new_bie/features/profile/ui/my_profile_page.dart';
import 'package:new_bie/features/profile/ui/notice_detail_page.dart';
import 'package:new_bie/features/profile/ui/notices_page.dart';
import 'package:new_bie/features/profile/ui/question_page.dart';
import 'package:new_bie/features/profile/ui/set_profile_page.dart';
import 'package:new_bie/features/profile/ui/setting_page.dart';
import 'package:new_bie/features/profile/ui/user_profile_page.dart';
import 'package:new_bie/features/profile/viewmodel/my_profile_view_model.dart';
import 'package:new_bie/features/profile/viewmodel/notices_view_model.dart';
import 'package:new_bie/features/profile/viewmodel/set_profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

EventBus eventBus = EventBus();

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://syfgficcejjgtvpmtkzx.supabase.co',
    anonKey: // 인증키
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc',
  );
  await Future.delayed(Duration(milliseconds: 300)); // 초기화 기다림
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return AuthViewModel();
          },
        ),
        Provider(create: (context) => PostRepository()),
        Provider(create: (context) => NoticesRepository()),
        ChangeNotifierProvider(
          create: (context) {
            return NoticesViewModel(context.read<NoticesRepository>());
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
            return SetProfileViewModel();
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
    final AuthViewModel authVM = context.read<AuthViewModel>();

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
      initialLocation: '/splash',
      refreshListenable: authVM,
      redirect: (BuildContext context, GoRouterState state) {
        final bool isLoggedIn = authVM.isLoggedIn;
        debugPrint("[리디렉트] isLoggedIn: ${isLoggedIn}");
        final String currentRoute = state.uri.toString();
        debugPrint("[리디렉트] currentRoute: ${currentRoute}");
        final UserEntity? user = authVM.user;

        //로그인 되면 홈화면으로 이동
        if (isLoggedIn && currentRoute == '/login' && user?.nick_name != null) {
          return '/home';
        } else if (isLoggedIn && user?.nick_name == null) {
          return '/set_profile';
        }

        //접근 가능한 화면
        final List<String> publicRoutes = ['/login', '/splash', '/home'];
        // 비로그인인데 publicRoutes 중 어떤 것도 아닌 경우 로그인 페이지로(지선생)
        final bool isPublic = publicRoutes.any(
          (path) => currentRoute.startsWith(path),
        );
        if (!isLoggedIn && !isPublic) {
          return '/login';
        }

        return null;
      },
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
            return PostDetailPage(id: detailId);
          },
          routes: [
            GoRoute(
              path: '/edit',
              builder: (context, state) {
                final postId = state.pathParameters["id"] ?? "0";
                final int detailId = int.parse(postId);
                return PostEditPage(postId: detailId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/user_profile/:user_id',
          builder: (context, state) {
            final userId = state.pathParameters["user_id"] ?? "";
            return UserProfilePage(userId: userId);
          },
          routes: [
            GoRoute(
              path: '/follower',
              builder: (context, state) {
                // 쿼리 파라미터에서 initialTab 값을 가져옴. 없으면 기본값 0
                final tabIndexString =
                    state.uri.queryParameters['initialTab'] ?? '0';
                final initialTab = int.tryParse(tabIndexString) ?? 0;
                final targetUserId = state.pathParameters["user_id"] ?? "";
                return FollowerListPage(
                  initialTabIndex: initialTab,
                  targetUserId: targetUserId,
                );
              },
            ),
          ],
        ),
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(body: child, bottomNavigationBar: BottomNavBar());
          },
          routes: [
            GoRoute(
              path: '/splash',
              builder: (context, state) {
                return const SplashPage();
              },
            ),
            GoRoute(
              path: '/home',
              builder: (context, state) {
                return const HomeScreen();
              },
              routes: [
                GoRoute(
                  path: '/search',
                  builder: (context, state) {
                    return const SearchResultPage();
                  },
                ),
              ],
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
                    return const SettingPage();
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
                            return const NoticeDetailPage();
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
                  path: '/follower',
                  builder: (context, state) {
                    // 쿼리 파라미터에서 initialTab 값을 가져옴. 없으면 기본값 0
                    final tabIndexString =
                        state.uri.queryParameters['initialTab'] ?? '0';
                    final initialTab = int.tryParse(tabIndexString) ?? 0;
                    final currentUserId =
                        context.read<AuthViewModel>().user?.id ?? "";
                    return FollowerListPage(
                      initialTabIndex: initialTab,
                      targetUserId: currentUserId,
                    );
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
