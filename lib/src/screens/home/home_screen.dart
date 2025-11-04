import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("임시화면")),
      body: SafeArea(child: Column(children: [Text("임시화면입니다.")])),
    );
  }
}
