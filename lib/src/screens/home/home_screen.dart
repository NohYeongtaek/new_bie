import 'package:flutter/material.dart';
import 'package:new_bie/src/components/post_item.dart';
import 'package:new_bie/src/screens/home/home_view_model.dart';
import 'package:provider/provider.dart';

import '../../entity/post_with_profile_entity.dart';

// 홈화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("홈")),
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(),
                Row(),
                Text("최신순"),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: viewModel.fetchPosts,
                    child: ListView.builder(
                      // controller: viewModel.scrollController,
                      itemCount: viewModel.posts.length, // 뷰모델.list.length
                      itemBuilder: (context, index) {
                        final PostWithProfileEntity item =
                            viewModel.posts[index];
                        return PostItem(post: item);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
