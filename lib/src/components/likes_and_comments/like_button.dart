import 'package:flutter/material.dart';
import 'package:new_bie/src/components/likes_and_comments/likes_viewmodel.dart';
import 'package:provider/provider.dart';

// 뷰모델 주입하기,
class LikeButton extends StatelessWidget {
  final int postId;
  final int likes_count;
  const LikeButton({super.key, required this.postId, this.likes_count = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LikesViewmodel(postId, likes_count, context),
      child: Consumer<LikesViewmodel>(
        builder: (context, viewModel, child) {
          return InkWell(
            onTap: viewModel.likeToggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 10,
                children: [
                  viewModel.likeEntity != null
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border, color: Colors.red),
                  Text("${viewModel.likes_count}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
