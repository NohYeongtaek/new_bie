import 'package:flutter/material.dart';

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("공지사항 목록")),
      body: SafeArea(child: Column(children: [Text("공지사힝들입니다.")])),
    );
  }
}
