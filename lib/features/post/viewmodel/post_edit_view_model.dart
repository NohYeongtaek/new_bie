import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/category_type_entity.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/post_repository.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostEditViewModel extends ChangeNotifier {
  PostRepository _repository;
  final int postId;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final hashtagController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<CategoryTypeEntity> categoryList = [];
  List<CategoryTypeEntity> selectedCategoryList = [];
  List<XFile> addImageMediaFileList = [];
  List<String> urlList = [];
  List<String> deleteImageUrl = [];
  PostWithProfileEntity? post;

  // int inputCount = 0;

  // final TextEditingController textEditingController = TextEditingController();

  // 뷰모델 생성자, context를 통해 리포지토리를 받아올 수 있음.
  PostEditViewModel(BuildContext context, {required this.postId})
    : _repository = context.read<PostRepository>() {
    getPost();
    getCategoryTypeList();
    notifyListeners();
  }

  Future<void> getPost() async {
    post = await _repository.fetchPostItem(postId);
    print("post 가져옴 : ${post?.title}");
    titleController.text = post?.title ?? "";
    contentController.text = post?.content ?? "";
    urlList =
        post?.postImages.map((image) {
          return image.image_url;
        }).toList() ??
        [];
    selectedCategoryList =
        post?.categories.map((category) {
          return category.categoryType;
        }).toList() ??
        [];
    notifyListeners();
  }

  Future<void> getImages() async {
    addImageMediaFileList.addAll(await _picker.pickMultiImage());
    notifyListeners();
  }

  void removeNewImage(XFile image) {
    addImageMediaFileList.remove(image);
    notifyListeners();
  }

  void removeOldImage(String image) {
    urlList.remove(image);
    notifyListeners();
  }

  Future<void> getCategoryTypeList() async {
    categoryList = await _repository.getCategoryTypeList();
    notifyListeners();
  }

  void selectCategoriesToggle(CategoryTypeEntity categoryId) {
    if (selectedCategoryList.contains(categoryId)) {
      selectedCategoryList.remove(categoryId);
      notifyListeners();
    } else {
      selectedCategoryList.add(categoryId);
      notifyListeners();
    }
    notifyListeners();
  }

  void cancelCategory(CategoryTypeEntity category) {
    selectedCategoryList.remove(category);
    notifyListeners();
  }

  Future<bool> updatePost() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty)
      return false;
    if (addImageMediaFileList.length != 0) {
      for (var image in addImageMediaFileList) {
        String uploadedProfileImage = "";
        final String fileName = "${DateTime.now().millisecondsSinceEpoch}";
        final imgFile = File(image.path);
        try {
          await SupabaseManager.shared.supabase.storage
              .from("images")
              .upload(
                fileName,
                imgFile,
                fileOptions: const FileOptions(
                  headers: {
                    "Authorization":
                        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc",
                  },
                ),
              );
          uploadedProfileImage = SupabaseManager.shared.supabase.storage
              .from("images")
              .getPublicUrl(fileName);
          urlList.add(uploadedProfileImage);
        } catch (e) {
          print("${e}");
          return false;
        }
        print(urlList);
      }
    }
    List<int> categoryIds = selectedCategoryList.map((item) {
      return item.id;
    }).toList();
    try {
      await _repository.updatePost(
        postId,
        titleController.text,
        contentController.text,
        urlList,
        categoryIds,
      );
    } catch (e) {
      print("e");
      return false;
    }

    return true;
  }
  // 입력한 글자 수를 받아오는 함수
  // void handleTextInput(String input) {
  //   inputCount = input.length;
  //   notifyListeners();
  // }

  // Future 함수는 API나 Supabase, 메소드 채널과 사용할 때,
  // 처리를 하는데 시간이 걸리는 작업을 할때 사용됨.
  // 아래 함수 안 에서는 시간이 필요한 작업은 await를 사용 해야함
  // Future<void> function() async {
  //   try {
  //
  //   } catch (e) {
  //
  //   }
  //
  //   // 리빌딩, 리콤포지션 진행
  //   notifyListeners();
  // }
  // Future<void> function1() async {
  //   // 시간 지연 코드
  //   await Future.delayed(const Duration(milliseconds: 1700));
  //   notifyListeners();
  // }
}
