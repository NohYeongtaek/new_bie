import 'package:flutter/material.dart';
import 'package:new_bie/features/post/ui/components/likes_and_comments/viewmodel/likes_viewmodel.dart';
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
                children: [
                  Icon(
                    viewModel.likeEntity != null
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: viewModel.likeEntity != null
                        ? Colors.red
                        : Colors.grey,
                  ),
                  const SizedBox(width: 4),
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
