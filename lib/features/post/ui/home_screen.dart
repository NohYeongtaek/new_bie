import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/ui/components/post/post_item.dart';
import 'package:new_bie/features/post/viewmodel/home_view_model.dart';
import 'package:new_bie/features/post/viewmodel/search/search_result_view_model.dart';
import 'package:provider/provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String selectedCategory = "전체"; // 초기 선택 카테고리
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = context.watch<HomeViewModel>();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("홈")),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(),
//             SizedBox(
//               height: 60,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: viewModel.categoryList.length,
//                 itemBuilder: (context, index) {
//                   final String title = viewModel.categoryList[index];
//                   final bool isSelected = title == selectedCategory;
//
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           selectedCategory = title;
//                         });
//                         viewModel.ChangeCategory(title);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: isSelected
//                             ? Colors.orange
//                             : Colors.white,
//                         foregroundColor: isSelected
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                       child: Text(title),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: DropdownMenu<OrderByType>(
//                 initialSelection: viewModel.type,
//                 dropdownMenuEntries: [
//                   DropdownMenuEntry(value: OrderByType.newFirst, label: "최신순"),
//                   DropdownMenuEntry(
//                     value: OrderByType.oldFirst,
//                     label: "오래된 순",
//                   ),
//                   DropdownMenuEntry(
//                     value: OrderByType.likesFirst,
//                     label: "좋아요 순",
//                   ),
//                 ],
//                 onSelected: (value) {
//                   if (value != null) viewModel.ChangeOrder(value);
//                 },
//               ),
//             ),
//             Expanded(
//               child: RefreshIndicator(
//                 onRefresh: viewModel.handleRefresh,
//                 child: ListView.builder(
//                   controller: viewModel.scrollController,
//                   itemCount: viewModel.posts.length,
//                   itemBuilder: (context, index) {
//                     final PostWithProfileEntity item = viewModel.posts[index];
//                     return PostItem(post: item);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// 홈화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Color setColor(String title, String selectCategory) {
  //   if (title == selectCategory)
  //     return orangeColor;
  //   else
  //     return Colors.white;
  // }

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
                TextField(
                  controller: viewModel.keywordController,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요.',
                    suffixIcon: IconButton(
                      onPressed: () {
                        context.read<SearchResultViewModel>().search(
                          viewModel.keywordController.text,
                        );
                        context.push('/home/search');
                        viewModel.keywordReset();
                      },
                      icon: Icon(Icons.search),
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
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.ChangeCategory(title);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.orange
                                : Colors.white,
                            foregroundColor: isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                          child: Text(title),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownMenu<OrderByType>(
                    initialSelection: viewModel.type,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: OrderByType.newFirst,
                        label: "최신순",
                      ),
                      DropdownMenuEntry(
                        value: OrderByType.oldFirst,
                        label: "오래된 순",
                      ),
                      DropdownMenuEntry(
                        value: OrderByType.likesFirst,
                        label: "좋아요 순",
                      ),
                    ],
                    onSelected: (value) {
                      if (value != null) viewModel.ChangeOrder(value);
                    },
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
