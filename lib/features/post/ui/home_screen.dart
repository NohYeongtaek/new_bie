import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/ui/components/post/post_item.dart';
import 'package:new_bie/features/post/viewmodel/home_view_model.dart';
import 'package:new_bie/features/post/viewmodel/search/search_result_view_model.dart';
import 'package:provider/provider.dart';

// 홈화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("홈", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                    controller: viewModel.keywordController,
                    placeholder: '검색어를 입력하세요.',
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onSubmitted: (value) {
                      context.read<SearchResultViewModel>().search(value);
                      context.push('/home/search');
                      viewModel.keywordReset();
                    },
                    suffix: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.search,
                        size: 20,
                        color: blackColor,
                      ),
                      onPressed: () {
                        context.read<SearchResultViewModel>().search(
                          viewModel.keywordController.text,
                        );
                        context.push('/home/search');
                        viewModel.keywordReset();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.categoryList.length,
                    itemBuilder: (context, index) {
                      final String title = viewModel.categoryList[index];
                      final bool isSelected = title == viewModel.selectCategory;
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.ChangeCategory(title);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.orange
                                : Colors.transparent,
                            foregroundColor: isSelected
                                ? Colors.white
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            minimumSize: const Size(0, 0),
                          ),
                          child: Text(title),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: greedColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownMenu<OrderByType>(
                        initialSelection: viewModel.type,
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: OrderByType.newFirst,
                            label: "최신순",
                            style: MenuItemButton.styleFrom(
                              foregroundColor: orangeColor,
                            ),
                          ),
                          DropdownMenuEntry(
                            value: OrderByType.oldFirst,
                            label: "오래된 순",
                            style: MenuItemButton.styleFrom(
                              foregroundColor: orangeColor,
                            ),
                          ),
                          DropdownMenuEntry(
                            value: OrderByType.likesFirst,
                            label: "좋아요 순",
                            style: MenuItemButton.styleFrom(
                              foregroundColor: orangeColor,
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value != null) viewModel.ChangeOrder(value);
                        },
                        inputDecorationTheme: const InputDecorationTheme(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 4.0,
                          ),
                          isDense: true,
                          border: InputBorder.none,
                          suffixIconColor: orangeColor,
                        ),
                        menuStyle: MenuStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            greedColor,
                          ),
                          maximumSize: WidgetStateProperty.all<Size>(
                            Size(200, 200),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: viewModel.handleRefresh,
                    child: ListView.builder(
                      controller: viewModel.scrollController,
                      itemCount: viewModel.posts.length, // 뷰모델.list.length
                      itemBuilder: (context, index) {
                        final PostWithProfileEntity item =
                            viewModel.posts[index];
                        return PostItem(
                          post: item,
                          onDelete: () => viewModel.deletePost(item.id),
                          onLike: () => viewModel.likeToggle(index, item.id),
                        );
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
