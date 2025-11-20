import 'package:flutter/material.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';

// 제목
final TextStyle titleFontStyle = TextStyle(
  color: orangeColor,
  fontSize: 32, // 40까지도
  fontWeight: FontWeight.bold,
);

// 내용
final TextStyle contentFontStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

// 페이지 상단 앱바 부분
final TextStyle pageTitleFontStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

// 게시물 업로드 시간 등등
final TextStyle dateFontStyle = TextStyle(
  color: Colors.white54,
  fontSize: 14,
  fontWeight: FontWeight.normal,
);

// 음..... 가급적 사용 ㄴㄴ
final TextStyle normalFontStyle = TextStyle(
  color: orangeColor,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

// 버튼 글씨 -> 모든 버튼이 글씨채가 같을 수 없으니까
// 폰트 사이즈 올리고 회의시간이나 미팅시간에 보고해주시기 바랍니다.
final TextStyle buttonFontStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

// 좋아요 수, 댓글 수 개시글 피드 및 게시글 디테일에서 사용
final TextStyle countFontStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
);

// 최소 12 이상
