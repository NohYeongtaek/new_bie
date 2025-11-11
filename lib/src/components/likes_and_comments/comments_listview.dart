import 'package:flutter/material.dart';
import 'package:new_bie/src/components/likes_and_comments/comment_item.dart';
import 'package:new_bie/src/components/likes_and_comments/comments_viewmodel.dart';
import 'package:new_bie/src/ui_set/colors.dart';
import 'package:provider/provider.dart';

class CommentsListview extends StatelessWidget {
  final int postId;
  const CommentsListview({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CommentsViewmodel(postId, context),
      child: _CommentsListview(),
    );
  }
}

class _CommentsListview extends StatelessWidget {
  const _CommentsListview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentsViewmodel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(color: orangeColor, height: 1),
            Expanded(
              child: viewModel.commentsIdList.isEmpty
                  ? Center(child: Text("작성된 댓글이 없습니다.\n첫 댓글 작성 해보세요!"))
                  : ListView.builder(
                      // controller: viewModel.scrollController,
                      itemCount:
                          viewModel.commentsIdList.length, // 뷰모델.list.length
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: CommentItem(
                            comment_id: viewModel.commentsIdList[index],
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: viewModel.textEditingController,
                      decoration: const InputDecoration(
                        hintText: '댓글',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.insertComment();
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //       content: Text(
                      //           '해시태그 "${hashtagController.text}" 추가됨')),
                      // );
                      // hashtagController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('추가'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
