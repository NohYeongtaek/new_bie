import 'package:flutter/material.dart';

class BlockedUserPage extends StatelessWidget {
  const BlockedUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("차단된 사용지 목록")),
      body: SafeArea(child: Column(children: [Text("사용자가 차단한 사용자 목록입니다.")])),
    );
  }
}
