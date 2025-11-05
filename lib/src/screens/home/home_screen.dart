import 'package:flutter/material.dart';
import 'package:new_bie/src/components/post_item.dart';
import 'package:new_bie/src/entity/post_entity.dart';
import 'package:new_bie/src/screens/home/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel = context.read<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text("임시화면")),
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: viewModel.fetchPosts,
                    child: ListView.builder(
                      // controller: viewModel.scrollController,
                      itemCount: viewModel.posts.length, // 뷰모델.list.length
                      itemBuilder: (context, index) {
                        final PostEntity item = viewModel.posts[index];
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
