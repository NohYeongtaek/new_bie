import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/core/utils/extension/time_extension.dart';
import 'package:new_bie/core/utils/ui_set/fonts.dart';
import 'package:new_bie/features/block_users/viewmodel/blocked_user_view_model.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/ui/components/likes_and_comments/ui/comment_button.dart';
import 'package:new_bie/features/post/ui/components/likes_and_comments/ui/like_button.dart';
import 'package:new_bie/features/post/ui/components/profile/small_profile_component.dart';
import 'package:new_bie/features/post/viewmodel/post_detail_view_model.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatelessWidget {
  final int id;
  const PostDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    int postId = id;

    return ChangeNotifierProvider(
      create: (context) => PostDetailViewModel(postId, context),
      child: _PostDetailPage(postId: postId),
    );
  }
}

class _PostDetailPage extends StatelessWidget {
  final int postId;
  const _PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailViewModel>(
      builder: (context, viewModel, child) {
        PostWithProfileEntity? post = viewModel.post;
        PostUserEntity? user = post?.user;
        final String? userId =
            SupabaseManager.shared.supabase.auth.currentUser?.id;
        final String? blockId = user?.id;
        final Widget body = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: viewModel.fetchPost, // 뷰모델에서 새로고침
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SmallProfileComponent(
                                nickName: user?.nick_name ?? "",
                                imageUrl: user?.profile_image,
                                introduce: "${post?.created_at.toTimesAgo()}",
                              ),
                            ),
                            user?.id ==
                                    SupabaseManager
                                        .shared
                                        .supabase
                                        .auth
                                        .currentUser
                                        ?.id
                                ? PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        onTap: () {
                                          context.push("/post/${postId}/edit");
                                        },
                                        child: Text("수정"),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {},
                                        child: Text("삭제"),
                                      ),
                                    ],
                                  )
                                : PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        onTap: () {},
                                        child: Text("신고"),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          context
                                              .read<BlockedUserViewModel>()
                                              .addBlockUser(userId!, blockId!);
                                        },
                                        child: Text("차단"),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                        Text(post?.title ?? "", style: titleFontStyle),
                        Text(post?.content ?? "", style: contentFontStyle),
                        if (viewModel.images.length != 0)
                          SizedBox(
                            height: 500,
                            child: PageView.builder(
                              controller: viewModel.pageController,
                              onPageChanged: viewModel.onChangedPage,
                              itemCount: viewModel.post?.postImages.length,
                              itemBuilder: (context, index) {
                                final url = viewModel.images[index];
                                double size = double.infinity;
                                double height = size;
                                return Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  width: size,
                                  height: height,
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  LikeButton(postId: postId),
                  CommentButton(
                    comments_count: post?.comments_count ?? 0,
                    postId: postId,
                  ),
                ],
              ),
            ),
          ],
        );
        return Scaffold(
          appBar: AppBar(title: Text("게시물")),
          body: SafeArea(
            child: post != null ? body : CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
