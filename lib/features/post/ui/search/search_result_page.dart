import 'package:flutter/material.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/post/viewmodel/search/search_result_view_model.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchResultViewModel(context),
      child: Consumer<SearchResultViewModel>(
        builder: (context, viewModel, child) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: TextField(
                  decoration: InputDecoration(
                    hint: Text("검색어를 입력하세요"),
                    border: InputBorder.none,
                  ),
                ),
                bottom: const TabBar(
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
              body: TabBarView(children: []),
            ),
          );
        },
      ),
    );
  }
}
