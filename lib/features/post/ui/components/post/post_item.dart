import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/core/utils/callback/callbacks.dart';
import 'package:new_bie/core/utils/extension/time_extension.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/core/utils/ui_set/fonts.dart';
import 'package:new_bie/features/block_users/viewmodel/blocked_user_view_model.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/ui/components/likes_and_comments/ui/like_button.dart';
import 'package:provider/provider.dart';

import '../likes_and_comments/ui/comment_button.dart';
import '../profile/small_profile_component.dart';

class PostItem extends StatelessWidget {
  final PostWithProfileEntity post;
  final DeletePostCallback onDelete;
  final LikeCallback? onLike;
  final void Function()? likeFunction;

  PostItem({
    super.key,
    required this.post,
    required this.onDelete,
    this.onLike,
    this.likeFunction,
  });

  @override
  Widget build(BuildContext context) {
    final String? currentUserId =
        SupabaseManager.shared.supabase.auth.currentUser?.id;

    return InkWell(
      onTap: () {
        context.push('/post/${post.id}');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: greedColor,
            border: Border.all(color: greedColor),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SmallProfileComponent(
                      imageUrl: post.user.profile_image,
                      nickName: post.user.nick_name ?? "",
                      introduce: post.created_at.toTimesAgo(),
                      userId: post.user.id,
                    ),
                  ),
                  if (post.user.id != currentUserId)
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(onTap: () {}, child: Text("신고")),
                        PopupMenuItem(
                          onTap: () {
                            if (currentUserId != null) {
                              context.read<BlockedUserViewModel>().addBlockUser(
                                currentUserId,
                                post.user.id,
                              );
                            }
                          },
                          child: Text("차단"),
                        ),
                      ],
                    ),
                ],
              ),

              // 제목
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(post.title ?? "제목 없음", style: titleFontStyle),
              ),

              // 이미지 리스트
              if (post.postImages.isNotEmpty)
                SizedBox(
                  height: 216,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: post.postImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          post.postImages[index].image_url,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),

              // 내용
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  post.content ?? "내용 없음",
                  style: contentFontStyle,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // 카테고리
              if (post.categories.isNotEmpty)
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: post.categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: orangeColor,
                            child: Text(
                              post.categories[index].categoryType.type_title,
                              style: TextStyle(color: blackColor, fontSize: 12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // 좋아요 + 댓글
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (onLike == null)
                      LikeButton(postId: post.id, likes_count: post.likes_count)
                    else
                      InkWell(
                        onTap: () => onLike?.call(),
                        child: Row(
                          children: [
                            Icon(
                              post.isLiked == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: post.isLiked == true
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text("${post.likes_count}"),
                          ],
                        ),
                      ),
                    SizedBox(width: 16),
                    CommentButton(
                      comments_count: post.comments_count,
                      postId: post.id,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
