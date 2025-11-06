import 'package:flutter/material.dart';
import 'package:new_bie/src/components/small_profile_component.dart';
import 'package:new_bie/src/entity/post_with_profile_entity.dart';
import 'package:new_bie/src/screens/post/post_detail_view_model.dart';
import 'package:provider/provider.dart';

import '../../ui_set/fonts.dart';

class PostDetailPage extends StatelessWidget {
  final int id;
  const PostDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    int postId = id;

    return ChangeNotifierProvider(
      create: (context) => PostDetailViewModel(postId, context),
      child: _PostDetailPage(),
    );
  }
}

class _PostDetailPage extends StatelessWidget {
  const _PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailViewModel>(
      builder: (context, viewModel, child) {
        PostWithProfileEntity? post = viewModel.post;
        PostUserEntity? user = post?.user;
        final Widget body = RefreshIndicator(
          onRefresh: viewModel.fetchPost, // 뷰모델에서 새로고침
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SmallProfileComponent(
                    nickName: user?.nick_name ?? "",
                    imageUrl: user?.profile_image ?? "",
                    introduce: post?.created_at ?? "",
                  ),
                  Text(post?.title ?? "", style: titleFontStyle),
                  Text(post?.content ?? "", style: contentFontStyle),
                ],
              ),
            ),
          ),
        );
        return Scaffold(
          appBar: AppBar(title: Text("게시물")),
          body: post != null ? body : CircularProgressIndicator(),
        );
      },
    );
  }
}
