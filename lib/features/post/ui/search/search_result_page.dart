import 'package:flutter/material.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("검색 결과 화면입니다.")),
      body: SafeArea(child: Column(children: [Text("검색 결과입니다.")])),
    );
  }
}
