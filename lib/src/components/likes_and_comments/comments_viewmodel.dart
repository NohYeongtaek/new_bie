import 'package:flutter/material.dart';
import 'package:new_bie/main.dart';
import 'package:new_bie/src/event_bus/comment_event_bus.dart';
import 'package:new_bie/src/managers/supabase_manager.dart';
import 'package:new_bie/src/screens/post/post_repository.dart';
import 'package:provider/provider.dart';

class CommentsViewmodel extends ChangeNotifier {
  // int inputCount = 0;
  final PostRepository _repository;

  final TextEditingController textEditingController = TextEditingController();
  final int postId;
  List<int> commentsIdList = [];

  // 뷰모델 생성자, context를 통해 리포지토리를 받아올 수 있음.
  CommentsViewmodel(this.postId, BuildContext context)
    : _repository = context.read<PostRepository>() {
    fetchCommentsId();
    eventBus.on<CommentEvent>().listen((event) {
      switch (event.type) {
        case CommentEventType.commentDelete:
          refreshCommentsId();
          break;
      }
    });
  }

  Future<void> fetchCommentsId() async {
    commentsIdList = await _repository.fetchCommentIds(postId);
    notifyListeners();
  }

  Future<void> refreshCommentsId() async {
    commentsIdList = [];
    commentsIdList = await _repository.fetchCommentIds(postId);
    notifyListeners();
  }

  Future<void> insertComment() async {
    final userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    if (userId == null) return;
    if (textEditingController.text.isEmpty) return;

    try {
      await _repository.insertComment(
        postId,
        userId,
        textEditingController.text,
      );
    } catch (e) {
      print("댓글 작성 실패 : ${e}");
      return;
    }
    textEditingController.text = "";
    await Future.delayed(const Duration(milliseconds: 1700));
    commentsIdList = await _repository.fetchCommentIds(postId);
    notifyListeners();
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
