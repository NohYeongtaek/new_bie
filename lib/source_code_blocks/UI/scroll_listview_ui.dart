import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 복붙용
class ScrollListviewUi extends StatelessWidget {
  const ScrollListviewUi({super.key});

  Future<void> function1() async {}

  @override
  Widget build(BuildContext context) {
    // Consumer<뷰모델>
    // 밑에 Consumer 부분 가져가서 사용하시면 됩니다.
    return Consumer(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: function1,
                child: ListView.builder(
                  // controller: viewModel.scrollController,
                  itemCount: 10, // 뷰모델.list.length
                  itemBuilder: (context, index) {
                    return ListTile(title: Text("예: post 컴포넌트 ${index}"));
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
