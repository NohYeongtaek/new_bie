import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ★ 여기에 원하는 라우트로 이동
        context.go('/home'); // 홈으로 이동

        return false; // 뒤로가기 기본 동작 막기
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "일지",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text("일지는 개발 예정 ㅋ", style: TextStyle(fontSize: 50)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
