import 'package:flutter/material.dart';
import '../ui_set/fonts.dart';
import '../ui_set/colors.dart';

class PostTitle extends StatelessWidget {
  final String title;

  const PostTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10), // 좌우여백 10
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4), // 내부여백 4
        decoration: BoxDecoration( // 박스 스타일
          //color: Colors.blue, // 박스모양 볼때
          borderRadius: BorderRadius.circular(8), // 모서리
        ),
        child: Text(
          title,
          style: titleFontStyle,
        ),
      ),
    );
  }
}
