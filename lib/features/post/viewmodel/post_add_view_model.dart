import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostAddViewModel extends ChangeNotifier {
  // int inputCount = 0;

  // final TextEditingController textEditingController = TextEditingController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final hashtagController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> mediaFileList = [];
  List<String> urlList = [];
  // 뷰모델 생성자, context를 통해 리포지토리를 받아올 수 있음.
  PostAddViewModel(BuildContext context) {}

  Future<void> getImages() async {
    mediaFileList = await _picker.pickMultiImage();
    notifyListeners();
  }

  Future<void> uploadSelectedImages() async {
    if (mediaFileList.length == 0) {
      return;
    }

    for (var image in mediaFileList) {
      String uploadedProfileImage = "";
      final String fileName = "${DateTime.now().millisecondsSinceEpoch}";
      final imgFile = File(image.path);
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
      print(urlList);
    }
    // mediaFileList.forEach((image) async {
    //   String uploadedProfileImage = "";
    //   final String fileName = "${DateTime.now().millisecondsSinceEpoch}";
    //   final imgFile = File(image.path);
    //   await SupabaseManager.shared.supabase.storage
    //       .from("images")
    //       .upload(
    //         fileName,
    //         imgFile,
    //         fileOptions: const FileOptions(
    //           headers: {
    //             "Authorization":
    //                 "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc",
    //           },
    //         ),
    //       );
    //   uploadedProfileImage = SupabaseManager.shared.supabase.storage
    //       .from("images")
    //       .getPublicUrl(fileName);
    //   urlList.add(uploadedProfileImage);
    //   print(urlList);
    // });
    print(urlList);
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
