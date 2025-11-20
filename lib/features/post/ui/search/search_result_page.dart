import 'package:flutter/cupertino.dart';
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
    super.initState();
    context.read<SearchResultViewModel>().initializeTabController(this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchResultViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            // ⬇️ 검색창을 title에 다시 배치합니다. (TabBar 위에 위치) ⬇️
            title: CupertinoTextField(
              controller: viewModel.keywordController,
              placeholder: '검색어를 입력하세요.',
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(8),
              ),
              onSubmitted: (value) {
                viewModel.searchAtResultPage();
              },
              suffix: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.search,
                  size: 20,
                  color: blackColor,
                ),
                onPressed: () {
                  viewModel.searchAtResultPage();
                },
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
          // ⬆️ body 수정 완료 ⬆️
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
    // 화면 높이 계산 (스크롤 뷰 내에서 중앙처럼 보이게 하기 위함)
    final mediaQuery = MediaQuery.of(context);
    // AppBar 높이 (56.0), TabBar 높이 (56.0), 상단 검색창 높이 (약 56.0)를 대략적으로 뺌
    final totalHeight =
        mediaQuery.size.height - mediaQuery.padding.top - 56.0 - 56.0 - 56.0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (viewModel.posts.length == 0 && viewModel.users.length == 0)
            SizedBox(
              height: totalHeight * 0.93,
              child: Center(
                child: Text("검색 결과가 없습니다.", style: TextStyle(fontSize: 25)),
              ),
            ),
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
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(orangeColor),
                  ),
                  child: Text(
                    "유저 검색결과 보러가기",
                    style: TextStyle(color: Colors.white),
                  ),
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
                      onLike: () => viewModel.likeToggle(
                        index,
                        viewModel.posts[index].id,
                      ),
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
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
          child: Text("검색 결과 : 게시물 ${viewModel.posts.length}개"),
        ),
        if (viewModel.posts.length == 0)
          Expanded(
            child: Center(
              child: Text("검색 결과가 없습니다.", style: TextStyle(fontSize: 25)),
            ),
          ),
        if (viewModel.posts.length > 0)
          Expanded(
            child: RefreshIndicator(
              onRefresh: viewModel.refreshPostPage,
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: viewModel.postScrollController,
                itemCount: viewModel.posts.length,
                itemBuilder: (context, index) {
                  return PostItem(
                    post: viewModel.posts[index],
                    onDelete: () =>
                        viewModel.deletePost(viewModel.posts[index].id),
                    onLike: () =>
                        viewModel.likeToggle(index, viewModel.posts[index].id),
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
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
          child: Text("검색 결과 : 유저 ${viewModel.users.length}명"),
        ),
        if (viewModel.users.length == 0)
          Expanded(
            child: Center(
              child: Text("검색 결과가 없습니다.", style: TextStyle(fontSize: 25)),
            ),
          ),
        if (viewModel.users.length > 0)
          Expanded(
            child: RefreshIndicator(
              onRefresh: viewModel.refreshPostPage,
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: viewModel.userScrollController,
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
            ),
          ),
      ],
    );
  }
}
