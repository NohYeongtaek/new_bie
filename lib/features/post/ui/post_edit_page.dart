import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/post/data/entity/category_type_entity.dart';
import 'package:new_bie/features/post/viewmodel/post_edit_view_model.dart';
import 'package:provider/provider.dart';

class PostEditPage extends StatelessWidget {
  final int postId;
  const PostEditPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostEditViewModel(context, postId: postId),
      child: Consumer<PostEditViewModel>(
        builder: (context, viewModel, child) {
          return viewModel.isWorking == true
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  appBar: AppBar(
                    title: const Text('게시글 수정'),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // actions: [
                    //   TextButton(
                    //     onPressed: () async {
                    //       bool isDone = await viewModel.updatePost();
                    //       if (isDone) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text('수정 되었습니다.')),
                    //         );
                    //         context.pop();
                    //       }
                    //       ;
                    //     },
                    //     child: const Text(
                    //       '수정',
                    //       style: TextStyle(
                    //         color: Colors.blue,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ],
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
                          Text("기존 이미지 : ${viewModel.urlList.length}장"),
                          if (viewModel.urlList.length != 0)
                            SizedBox(
                              height: 166,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: viewModel.urlList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        viewModel.removeOldImage(
                                          viewModel.urlList[index],
                                        );
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        child: Image.network(
                                          viewModel.urlList[index],
                                          fit: BoxFit.cover,
                                          width: 150,
                                          height: 150,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          Text(
                            "새 이미지 : ${viewModel.addImageMediaFileList.length}장",
                          ),
                          if (viewModel.addImageMediaFileList.length != 0)
                            SizedBox(
                              height: 166,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    viewModel.addImageMediaFileList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        viewModel.removeNewImage(
                                          viewModel
                                              .addImageMediaFileList[index],
                                        );
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        child: Image.file(
                                          File(
                                            viewModel
                                                .addImageMediaFileList[index]
                                                .path,
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
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    bool isDone = await viewModel.updatePost();
                                    if (isDone) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('수정 되었습니다.'),
                                        ),
                                      );
                                      context.pop();
                                    }
                                    ;
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: orangeColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                  ),
                                  child: const Text(
                                    '수정',
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
                                itemCount:
                                    viewModel.selectedCategoryList.length,
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
      ),
    );
  }
}

// 버튼 안에 리빌딩이 제대로 안된다.
class _selectCategoryTypeBottomSheetList extends StatefulWidget {
  final PostEditViewModel viewModel;
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
