import 'package:flutter/material.dart';

class FollowListPage extends StatelessWidget {
  const FollowListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("팔로잉/팔로우")),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("팔로잉"), Text("팔로워")],
        ),
      ),
    );
  }
}
