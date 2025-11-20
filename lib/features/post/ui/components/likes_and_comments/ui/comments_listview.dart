import 'package:flutter/material.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/post/ui/components/likes_and_comments/ui/comment_item.dart';
import 'package:new_bie/features/post/ui/components/likes_and_comments/viewmodel/comments_viewmodel.dart';
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
        return viewModel.isWorking
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(color: orangeColor, height: 1),
                  Expanded(
                    child: viewModel.commentsList.isEmpty
                        ? Center(
                            child: Text(
                              "작성된 댓글이 없습니다.\n첫 댓글 작성 해보세요!",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            // controller: viewModel.scrollController,
                            itemCount: viewModel
                                .commentsList
                                .length, // 뷰모델.list.length
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: CommentItem(
                                  currentCommentIndex:
                                      viewModel.selectCommentIndex,
                                  comment: viewModel.commentsList[index],
                                  commentIndex: index,
                                  // comment_id: viewModel.commentsIdList[index],
                                  viewModel: viewModel,
                                  onDelete: () => viewModel.deleteComment(
                                    index,
                                    viewModel.commentsList[index].id,
                                  ),
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
                            style: TextStyle(color: Colors.white),
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
                            backgroundColor: orangeColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            '추가',
                            style: TextStyle(color: Colors.white),
                          ),
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
