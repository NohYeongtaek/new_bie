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
  void Function()? likeFunction = () {};

  // final String? title;
  // final String? content;
  // final String created_at;

  PostItem({
    super.key,
    // this.title,
    // this.content,
    // required this.created_at,
    this.onLike,
    required this.post,
    this.likeFunction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String? userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    final String blockId = post.user.id;
    return InkWell(
      onTap: () {
        context.push('/post/${post.id}');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: SmallProfileComponent(
                    imageUrl: post.user.profile_image,
                    nickName: post.user.nick_name ?? "",
                    introduce: "${post.created_at.toTimesAgo()}",
                    userId: post.user.id,
                  ),
                ),
                if (post.user.id !=
                    SupabaseManager.shared.supabase.auth.currentUser?.id)
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(onTap: () {}, child: Text("신고")),
                      PopupMenuItem(
                        onTap: () {
                          context.read<BlockedUserViewModel>().addBlockUser(
                            userId!,
                            blockId!,
                          );
                        },
                        child: Text("차단"),
                      ),
                    ],
                  ),
              ],
            ),
            Text(post.title ?? "제목 없음", style: titleFontStyle),
            if (post.postImages.length != 0)
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
            Text(
              post.content ?? "내용 없음",
              style: contentFontStyle,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
            if (post.categories.length != 0)
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  onLike == null
                      ? LikeButton(
                          postId: post.id,
                          likes_count: post.likes_count,
                        )
                      : InkWell(
                          onTap: () {
                            onLike!();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                const SizedBox(width: 4),
                                Text("${post.likes_count}"),
                              ],
                            ),
                          ),
                        ),
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
