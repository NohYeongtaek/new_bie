import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/home')) currentIndex = 0;
    if (location.startsWith('/search')) currentIndex = 1;
    if (location.startsWith('/profile')) currentIndex = 2;
    if (location.startsWith('/open_chat')) currentIndex = 3;
    if (location.startsWith('/memo')) currentIndex = 4;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/search');
            break;
          case 2:
            //TODO: 인증상태를 확인
            // 인증이 되었다면 이동
            final bool isLoggedIn = context.read<AuthViewModel>().isLoggedIn;
            if (isLoggedIn) {
              context.go('/profile');
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: "테스트",
                    message: "로그인이 필요합니다.",
                    onConfirm: () {},
                  );
                },
              );
            }
            break;
          case 3:
            context.go('/open_chat');
            break;
          case 4:
            context.go('/memo');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: '새글'),
        BottomNavigationBarItem(icon: Icon(Icons.edit_calendar), label: '일지'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
      ],
    );
  }
}
