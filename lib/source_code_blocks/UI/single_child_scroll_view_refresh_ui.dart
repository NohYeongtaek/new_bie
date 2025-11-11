import 'package:flutter/material.dart';

// 복붙용 코드
class SingleChildScrollViewRefreshUi extends StatelessWidget {
  const SingleChildScrollViewRefreshUi({super.key});

  Future<void> function1() async {}

  @override
  Widget build(BuildContext context) {
    // RefreshIndicator 부분을 복사해서 가져가시길. 여기에 작성하지 마세요.
    // 게시물 디테일, 공지 디테일 등등 단일 페이지에서 스크롤 가능하게끔 만들어진 코드입니다.
    // 아래의 Consumer 안에서 사용 해야 합니다. 뷰모델 사용을 사용 하세요.
    return RefreshIndicator(
      onRefresh: function1, // 뷰모델에서 새로고침
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Text("제목")],
          ),
        ),
      ),
    );
  }
}

// Consumer 사용하는 예시
// Consumer<viewmodel>(
//   builder: (context, viewModel, child) {
//     return 위젯
//   }
// )
