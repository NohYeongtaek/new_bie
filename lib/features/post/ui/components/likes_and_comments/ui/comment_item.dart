import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/core/utils/callback/callbacks.dart';
import 'package:new_bie/core/utils/extension/time_extension.dart';
import 'package:new_bie/core/utils/ui_set/fonts.dart';
import 'package:new_bie/features/block_users/viewmodel/blocked_user_view_model.dart';
import 'package:new_bie/features/post/data/entity/comment_with_profile_entity.dart';
import 'package:new_bie/features/post/ui/components/likes_and_comments/viewmodel/comments_viewmodel.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatelessWidget {
  // final int comment_id;
  final String? imageUrl = null;
  final CommentWithProfileEntity comment;
  final DeletePostCallback? onDelete;
  final int? currentCommentIndex;
  final int commentIndex;
  final CommentsViewmodel viewModel;
  const CommentItem({
    super.key,
    // required this.comment_id,
    required this.onDelete,
    required this.comment,
    required this.currentCommentIndex,
    required this.commentIndex,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final double imageSize = 40;
    final Widget body = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          InkWell(
            onTap: () {
              if (comment.user.id ==
                  SupabaseManager.shared.supabase.auth.currentUser?.id) {
                context.push('/my_profile');
              } else {
                context.push("/user_profile/${comment.user.id}");
              }
            },
            child: SizedBox(
              width: imageSize,
              height: imageSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: comment.user.profile_image == null
                    ? Image.asset('assets/images/user.png', fit: BoxFit.cover)
                    : Image.network(
                        comment.user.profile_image ?? "",
                        fit: BoxFit.cover,
                      ),
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
                      comment.user.nick_name ?? "",
                      style: normalFontStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      comment.createdAt.toTimesAgo() ?? "",
                      style: dateFontStyle,
                    ),
                  ],
                ),
                Text(comment.content ?? "", style: contentFontStyle),
              ],
            ),
          ),
          // 자기 자신의 id 면 수정,삭제를 띄우고 아니면 신고, 차단을 띄워라
          comment.user.id ==
                  SupabaseManager.shared.supabase.auth.currentUser?.id
              ? PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        viewModel.startEdit(commentIndex);
                      },
                      child: Text("수정"),
                    ),
                    PopupMenuItem(onTap: onDelete, child: Text("삭제")),
                  ],
                )
              : PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(onTap: () {}, child: Text("신고")),
                    PopupMenuItem(
                      onTap: () {
                        final userId = SupabaseManager
                            .shared
                            .supabase
                            .auth
                            .currentUser
                            ?.id;
                        if (userId != null) {
                          context.read<BlockedUserViewModel>().addBlockUser(
                            userId,
                            comment.user.id,
                          );
                        }
                      },
                      child: Text("차단"),
                    ),
                  ],
                ),
        ],
      ),
    );
    Widget editMode = Row(
      children: [
        Expanded(
          child: TextField(controller: viewModel.commentUpdatingController),
        ),
        Row(
          spacing: 10,
          children: [
            IconButton(
              onPressed: () {
                viewModel.editComment(commentIndex, comment.id);
              },
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
    return commentIndex == currentCommentIndex ? editMode : body;
  }
}

// class _CommentItem extends StatelessWidget {
//   const _CommentItem({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CommentItemViewmodel>(
//       builder: (context, viewModel, child) {
//         final String? userId =
//             SupabaseManager.shared.supabase.auth.currentUser?.id;
//         final String? blockId = viewModel.comment?.user.id;
//         final double imageSize = 40;
//         PostUserEntity? user = viewModel.comment?.user;
//         final Widget body = Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 10,
//             children: [
//               InkWell(
//                 onTap: () {
//                   if (comment.user.id ==
//                       SupabaseManager.shared.supabase.auth.currentUser?.id) {
//                     context.push('/my_profile');
//                   } else {
//                     context.push("/user_profile/${viewModel.comment?.user.id}");
//                   }
//                 },
//                 child: SizedBox(
//                   width: imageSize,
//                   height: imageSize,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: viewModel.comment?.user.profile_image == null
//                         ? Image.asset(
//                             'assets/images/user.png',
//                             fit: BoxFit.cover,
//                           )
//                         : Image.network(
//                             viewModel.comment?.user.profile_image ?? "",
//                             fit: BoxFit.cover,
//                           ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       spacing: 10,
//                       children: [
//                         Text(
//                           user?.nick_name ?? "",
//                           style: normalFontStyle,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Text(
//                           viewModel.comment?.createdAt.toTimesAgo() ?? "",
//                           style: dateFontStyle,
//                         ),
//                       ],
//                     ),
//                     Text(
//                       viewModel.comment?.content ?? "",
//                       style: contentFontStyle,
//                     ),
//                   ],
//                 ),
//               ),
//               // 자기 자신의 id 면 수정,삭제를 띄우고 아니면 신고, 차단을 띄워라
//               viewModel.comment?.user.id ==
//                       SupabaseManager.shared.supabase.auth.currentUser?.id
//                   ? PopupMenuButton(
//                       itemBuilder: (context) => [
//                         PopupMenuItem(
//                           onTap: viewModel.startEdit,
//                           child: Text("수정"),
//                         ),
//                         PopupMenuItem(
//                           onTap: viewModel.deleteComment,
//                           child: Text("삭제"),
//                         ),
//                       ],
//                     )
//                   : PopupMenuButton(
//                       itemBuilder: (context) => [
//                         PopupMenuItem(onTap: () {}, child: Text("신고")),
//                         PopupMenuItem(
//                           onTap: () {
//                             context.read<BlockedUserViewModel>().addBlockUser(
//                               userId!,
//                               blockId!,
//                             );
//                           },
//                           child: Text("차단"),
//                         ),
//                       ],
//                     ),
//             ],
//           ),
//         );
//         Widget editMode = Row(
//           children: [
//             Expanded(
//               child: TextField(controller: viewModel.textEditingController),
//             ),
//             Row(
//               spacing: 10,
//               children: [
//                 IconButton(
//                   onPressed: viewModel.editComment,
//                   icon: Icon(Icons.check, color: Colors.green),
//                 ),
//                 IconButton(
//                   onPressed: viewModel.cancelEdit,
//                   icon: Icon(Icons.cancel_outlined, color: Colors.red),
//                 ),
//               ],
//             ),
//           ],
//         );
//         return viewModel.isEdit ? editMode : body;
//       },
//     );
//   }
// }
