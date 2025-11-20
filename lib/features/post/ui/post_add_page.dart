import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/post/data/entity/category_type_entity.dart';
import 'package:new_bie/features/post/viewmodel/post_add_view_model.dart';
import 'package:provider/provider.dart';

class PostAddPage extends StatelessWidget {
  const PostAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostAddViewModel(context),
      child: WillPopScope(
        onWillPop: () async {
          context.go('/home');
          return false;
        },
        child: _PostAddPage(),
      ),
    );
  }
}

class _PostAddPage extends StatelessWidget {
  const _PostAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    void _submitPost(BuildContext context) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('게시물이 등록되었습니다.')));
    }

    return Consumer<PostAddViewModel>(
      builder: (context, viewModel, child) {
        return viewModel.isWorking == true
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  title: const Text(
                    '게시글 작성',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: greedColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: viewModel.titleController,
                              decoration: InputDecoration(
                                hintText: '제목을 입력하세요',
                                hintStyle: TextStyle(fontSize: 30),
                                border: const UnderlineInputBorder(),
                              ),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: greedColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: viewModel.contentController,
                              decoration: const InputDecoration(
                                hintText: '내용을 입력하세요',
                                border: UnderlineInputBorder(),
                              ),
                              maxLines: 24,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          // 👈 새로운 Row 위젯을 추가합니다.
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                viewModel.getImages();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/pictureIcon.png',
                                      width: 12,
                                      height: 12,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '사진 추가',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                showBarModalBottomSheet(
                                  expand: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _selectCategoryTypeBottomSheetList(
                                      viewModel: viewModel,
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/tagIcon.png',
                                      width: 12,
                                      height: 12,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '카테고리',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (viewModel.mediaFileList.length != 0)
                          SizedBox(
                            height: 166,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: viewModel.mediaFileList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      viewModel.removeNewImage(
                                        viewModel.mediaFileList[index],
                                      );
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      child: Image.file(
                                        File(
                                          viewModel.mediaFileList[index].path,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  bool isDone = await viewModel
                                      .uploadSelectedImages();
                                  if (isDone) {
                                    context.go('/home');
                                    _submitPost(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('게시물 등록 실패.'),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: orangeColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text(
                                  '등록',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        if (viewModel.selectedCategoryList.isNotEmpty)
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: viewModel.selectedCategoryList.length,
                              itemBuilder: (context, index) {
                                CategoryTypeEntity category =
                                    viewModel.selectedCategoryList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      viewModel.cancelCategory(category);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: orangeColor,
                                        child: Text(
                                          category.type_title,
                                          style: TextStyle(
                                            color: blackColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

// 버튼 안에 리빌딩이 제대로 안된다.
class _selectCategoryTypeBottomSheetList extends StatefulWidget {
  final PostAddViewModel viewModel;
  const _selectCategoryTypeBottomSheetList({
    super.key,
    required this.viewModel,
  });

  @override
  State<_selectCategoryTypeBottomSheetList> createState() =>
      _selectCategoryTypeBottomSheetListState();
}

class _selectCategoryTypeBottomSheetListState
    extends State<_selectCategoryTypeBottomSheetList> {
  List<String> selectCategory = [];
  @override
  void initState() {
    // TODO: implement initState
    selectCategory = widget.viewModel.selectedCategoryList.map((categoty) {
      return categoty.type_title;
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackColor,
      child: SizedBox(
        height: 300,
        child: ListView.builder(
          itemCount: widget.viewModel.categoryList.length,
          itemBuilder: (context, index) {
            CategoryTypeEntity category = widget.viewModel.categoryList[index];
            String categoryTypeName =
                widget.viewModel.categoryList[index].type_title;
            int categoryTypeId = widget.viewModel.categoryList[index].id;

            return InkWell(
              onTap: () {
                widget.viewModel.selectCategoriesToggle(category);
                setState(() {
                  if (selectCategory.contains(categoryTypeName)) {
                    selectCategory.remove(categoryTypeName);
                  } else {
                    selectCategory.add(categoryTypeName);
                  }
                });
              },
              child: Container(
                color: blackColor,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          categoryTypeName,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Icon(
                        selectCategory.contains(categoryTypeName)
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: selectCategory.contains(categoryTypeName)
                            ? orangeColor
                            : orangeColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
