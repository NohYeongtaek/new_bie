import 'package:flutter/material.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일지 페이지 To Be continue")),
      body: SafeArea(
        child: Center(child: Text("일지 페이지입니다\n추후 업데이트로 돌아오겠습니다.")),
      ),
    );
  }
}
