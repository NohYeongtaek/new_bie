import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/src/components/likes_and_comments/like_button.dart';
import 'package:new_bie/src/entity/post_with_profile_entity.dart';
import 'package:new_bie/src/extension/time_extension.dart';
import 'package:new_bie/src/managers/supabase_manager.dart';
import 'package:new_bie/src/ui_set/fonts.dart';

import 'likes_and_comments/comment_button.dart';
import 'small_profile_component.dart';

class PostItem extends StatelessWidget {
  final PostWithProfileEntity post;
  void Function()? likeFunction = () {};
  // final String? title;
  // final String? content;
  // final String created_at;

  PostItem({
    super.key,
    // this.title,
    // this.content,
    // required this.created_at,
    required this.post,
    this.likeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (SupabaseManager.shared.supabase.auth.currentUser?.id == null) {
          context.push('/login');
        } else {
          context.push('/post/${post.id}');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SmallProfileComponent(
              imageUrl: post.user.profile_image,
              nickName: post.user.nick_name,
              introduce: "${post.created_at.toTimesAgo()}",
            ),
            Text(post.title ?? "제목 없음", style: titleFontStyle),
            Text(
              post.content ?? "내용 없음",
              style: contentFontStyle,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  LikeButton(postId: post.id, likes_count: post.likes_count),
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
    );
  }
}
