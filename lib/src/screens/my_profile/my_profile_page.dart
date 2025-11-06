import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("data")),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              context.push('/login');
            },
            child: Text("로그인 버튼(임시)"),
          ),
        ),
      ),
    );
  }
}
