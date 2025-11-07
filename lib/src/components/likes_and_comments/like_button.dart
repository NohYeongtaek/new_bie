import 'package:flutter/material.dart';
import 'package:new_bie/src/components/likes_and_comments/likes_viewmodel.dart';
import 'package:provider/provider.dart';

// 뷰모델 주입하기,
class LikeButton extends StatelessWidget {
  final int postId;
  const LikeButton({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LikesViewmodel(postId, context),
      child: Consumer<LikesViewmodel>(
        builder: (context, viewModel, child) {
          return InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 10,
                children: [Icon(Icons.favorite), Text("0")],
              ),
            ),
          );
        },
      ),
    );
  }
}
