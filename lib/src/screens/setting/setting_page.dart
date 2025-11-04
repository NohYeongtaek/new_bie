import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("설정하기")),
      body: SafeArea(child: Column(children: [Text("설정 화면 입니다.")])),
    );
  }
}
