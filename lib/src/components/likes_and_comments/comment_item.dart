import 'package:flutter/material.dart';
import 'package:new_bie/src/components/likes_and_comments/comment_item_viewmodel.dart';
import 'package:new_bie/src/entity/post_with_profile_entity.dart';
import 'package:new_bie/src/extension/time_extension.dart';
import 'package:new_bie/src/managers/supabase_manager.dart';
import 'package:provider/provider.dart';

import '../../ui_set/fonts.dart';

class CommentItem extends StatelessWidget {
  final int comment_id;
  final String? imageUrl = null;
  const CommentItem({super.key, required this.comment_id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CommentItemViewmodel(comment_id, context),
      child: _CommentItem(imageUrl: imageUrl),
    );
    ;
  }
}

class _CommentItem extends StatelessWidget {
  const _CommentItem({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentItemViewmodel>(
      builder: (context, viewModel, child) {
        final double imageSize = 40;
        PostUserEntity? user = viewModel.comment?.user;
        final Widget body = Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 10,
            children: [
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: viewModel.comment?.user.profile_image == null
                        ? Image.asset(
                            'assets/images/user.png',
                            fit: BoxFit.cover,
                          )
                        : Image.network(imageUrl!, fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 10,
                      children: [
                        Text(
                          user?.nick_name ?? "",
                          style: normalFontStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          viewModel.comment?.createdAt.toTimesAgo() ?? "",
                          style: dateFontStyle,
                        ),
                      ],
                    ),
                    Text(
                      viewModel.comment?.content ?? "",
                      style: contentFontStyle,
                    ),
                  ],
                ),
              ),
              // ?SupabaseManager.shared.supabase.auth.currentUser?.id ==
              //         viewModel.comment?.user.id
              //     ? IconButton(
              //         icon: Icon(Icons.delete),
              //         onPressed: () {
              //           viewModel.deleteComment();
              //         },
              //       )
              //     : null,
              viewModel.comment?.user.id ==
                      SupabaseManager.shared.supabase.auth.currentUser?.id
                  ? PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: viewModel.startEdit,
                          child: Text("수정"),
                        ),
                        PopupMenuItem(
                          onTap: viewModel.deleteComment,
                          child: Text("삭제"),
                        ),
                      ],
                    )
                  : PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(onTap: () {}, child: Text("신고")),
                        PopupMenuItem(onTap: () {}, child: Text("차단")),
                      ],
                    ),
            ],
          ),
        );
        Widget editMode = Row(
          children: [
            Expanded(
              child: TextField(controller: viewModel.textEditingController),
            ),
            Row(
              spacing: 10,
              children: [
                IconButton(
                  onPressed: viewModel.editComment,
                  icon: Icon(Icons.check, color: Colors.green),
                ),
                IconButton(
                  onPressed: viewModel.cancelEdit,
                  icon: Icon(Icons.cancel_outlined, color: Colors.red),
                ),
              ],
            ),
          ],
        );
        return viewModel.isEdit ? editMode : body;
      },
    );
  }
}
