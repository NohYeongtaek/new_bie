import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/post/ui/components/post/post_item.dart';
import 'package:new_bie/features/post/ui/components/profile/small_profile_component.dart';
import 'package:new_bie/features/post/viewmodel/search/search_result_view_model.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SearchResultViewModel>().initializeTabController(this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchResultViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: viewModel.keywordController,
              decoration: InputDecoration(
                hint: Text("검색어를 입력하세요"),
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<SearchResultViewModel>().searchAtResultPage();
                  },
                  icon: Icon(Icons.search),
                ),
                border: InputBorder.none,
              ),
            ),
            bottom: TabBar(
              controller: viewModel.tabController,
              isScrollable: true,
              indicatorColor: orangeColor,
              labelColor: orangeColor,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: "전체"),
                Tab(text: "게시글"),
                Tab(text: "사용자"),
              ],
            ),
          ),
          body: TabBarView(
            controller: viewModel.tabController,
            children: [
              SearchAllView(viewModel: viewModel),
              SearchPostView(viewModel: viewModel),
              SearchUserView(viewModel: viewModel),
            ],
          ),
        );
      },
    );
  }
}

class SearchAllView extends StatelessWidget {
  const SearchAllView({super.key, required this.viewModel});
  final SearchResultViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (viewModel.posts.length == 0 && viewModel.users.length == 0)
            Center(child: Text("검색 결과가 없습니다.")),
          if (viewModel.users.length > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("유저 : ${viewModel.users.length}명"),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: viewModel.users.length,
                  itemBuilder: (context, index) {
                    final user = viewModel.users[index];
                    final String? userProfileImage = user.profile_image;
                    return InkWell(
                      onTap: () {
                        context.push("/user_profile/${user.id}");
                      },
                      child: SmallProfileComponent(
                        imageUrl: userProfileImage,
                        nickName: user.nick_name ?? "",
                        introduce: user.introduction ?? "",
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.moveToTab(2);
                  },
                  child: Text("유저 검색결과 보러가기"),
                ),
              ],
            ),
          if (viewModel.posts.length > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("게시물 : ${viewModel.posts.length}개"),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: viewModel.posts.length,
                  itemBuilder: (context, index) {
                    return PostItem(
                      post: viewModel.posts[index],
                      onDelete: () =>
                          viewModel.deletePost(viewModel.posts[index].id),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.moveToTab(1);
                  },
                  child: Text("게시물 검색결과 보러가기"),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class SearchPostView extends StatelessWidget {
  final SearchResultViewModel viewModel;
  const SearchPostView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("검색 결과 : 게시물 ${viewModel.posts.length}개"),
        if (viewModel.posts.length == 0) Center(child: Text("검색결과가 없습니다.")),
        if (viewModel.posts.length > 0)
          Expanded(
            child: RefreshIndicator(
              onRefresh: viewModel.refreshPostPage,
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: viewModel.postScrollController,
                itemCount: viewModel.posts.length, // 뷰모델.list.length
                itemBuilder: (context, index) {
                  return PostItem(
                    post: viewModel.posts[index],
                    onDelete: () =>
                        viewModel.deletePost(viewModel.posts[index].id),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class SearchUserView extends StatelessWidget {
  final SearchResultViewModel viewModel;
  const SearchUserView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("검색 결과 : 유저 ${viewModel.users.length}명"),
        if (viewModel.users.length == 0) Center(child: Text("검색결과가 없습니다.")),
        if (viewModel.users.length > 0)
          Expanded(
            child: RefreshIndicator(
              onRefresh: viewModel.refreshPostPage,
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: viewModel.userScrollController,
                itemCount: viewModel.users.length, // 뷰모델.list.length
                itemBuilder: (context, index) {
                  final user = viewModel.users[index];
                  final String? userProfileImage = user.profile_image;
                  return InkWell(
                    onTap: () {
                      context.push("/user_profile/${user.id}");
                    },
                    child: SmallProfileComponent(
                      imageUrl: userProfileImage,
                      nickName: user.nick_name ?? "",
                      introduce: user.introduction ?? "",
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
