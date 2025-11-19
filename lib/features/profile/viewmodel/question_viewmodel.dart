import 'package:flutter/material.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';

//이것은 복붙용입니다. 혹시 몰라서 아직은 삭제하지 않으나 곧 삭제할 예정입니다.

class QuestionViewmodel extends ChangeNotifier {
  final emailController = TextEditingController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  bool isWork = false;
  // int inputCount = 0;

  // final TextEditingController textEditingController = TextEditingController();

  // 뷰모델 생성자, context를 통해 리포지토리를 받아올 수 있음.
  QuestionViewmodel(BuildContext context) {
    setEmail();
  }

  void setEmail() {
    final email = SupabaseManager.shared.supabase.auth.currentUser?.email;
    if (email != null) {
      emailController.text = email;
    }
    notifyListeners();
  }

  //문의 하기 함수
  Future<bool> sendQuestion() async {
    if (isWork) return false;
    isWork = true;
    notifyListeners();
    final String? userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    if (userId == null ||
        emailController.text.isEmpty ||
        titleController.text.isEmpty ||
        contentController.text.isEmpty) {
      isWork = false;
      notifyListeners();
      return false;
    }
    try {
      await SupabaseManager.shared.sendQuestion(
        userId,
        emailController.text,
        titleController.text,
        contentController.text,
      );
    } catch (e) {
      print("문의 전송 실패 : $e");
      isWork = false;
      notifyListeners();
      return false;
    }
    titleController.text = "";
    contentController.text = "";
    isWork = false;
    notifyListeners();
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
