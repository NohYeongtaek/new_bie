import 'package:flutter/material.dart';

class PostAddPage extends StatelessWidget {
  const PostAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("게시물 작성")),
      body: SafeArea(child: Column(children: [Text("게시물 작성 패이지입니다")])),
    );
  }
}
