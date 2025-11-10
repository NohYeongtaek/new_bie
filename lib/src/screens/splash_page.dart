import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui_set/fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // ⭐️ 1초 지연 후 화면 이동 (가장 일반적인 스플래시 패턴) ⭐️
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("/:new_bie", style: titleFontStyle),
              Text("프로그래머를 위한 커뮤니티", style: contentFontStyle),
            ],
          ),
        ),
      ),
    );
  }
}
