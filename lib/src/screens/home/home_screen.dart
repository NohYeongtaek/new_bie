import 'package:flutter/material.dart';

import '../../ui_set/fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("임시화면")),
      body: SafeArea(
        child: Column(
          children: [Text("임시화면입니다.", style: contentFontStyle as TextStyle)],
        ),
      ),
    );
  }
}
