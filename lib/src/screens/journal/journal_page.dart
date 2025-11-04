import 'package:flutter/material.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일지")),
      body: SafeArea(child: Column(children: [Text("일지는 개발 예정")])),
    );
  }
}
