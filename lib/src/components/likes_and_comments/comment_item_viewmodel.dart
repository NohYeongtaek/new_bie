import 'package:flutter/material.dart';
import 'package:new_bie/main.dart';
import 'package:new_bie/src/components/likes_and_comments/comments_viewmodel.dart';
import 'package:new_bie/src/entity/comment_with_profile_entity.dart';
import 'package:new_bie/src/event_bus/comment_event_bus.dart';
import 'package:new_bie/src/screens/post/post_repository.dart';
import 'package:provider/provider.dart';

//이것은 복붙용입니다. 혹시 몰라서 아직은 삭제하지 않으나 곧 삭제할 예정입니다.

class CommentItemViewmodel extends ChangeNotifier {
  // int inputCount = 0;
  PostRepository _repository;
  CommentsViewmodel _commentsViewmodel;
  bool isWorking = false;
  final int comment_id;
  CommentWithProfileEntity? comment;
  bool isEdit = false;
  final TextEditingController textEditingController = TextEditingController();

  // 뷰모델 생성자, context를 통해 리포지토리를 받아올 수 있음.
  CommentItemViewmodel(this.comment_id, BuildContext context)
    : _repository = context.read<PostRepository>(),
      _commentsViewmodel = context.read<CommentsViewmodel>() {
    fetchCommentItem();
  }

  Future<void> fetchCommentItem() async {
    comment = await _repository.fetchCommentItem(comment_id);
    notifyListeners();
  }

  Future<void> deleteComment() async {
    await _repository.deleteComment(comment_id);
    await Future.delayed(const Duration(milliseconds: 1700));
    eventBus.fire(CommentEvent(CommentEventType.commentDelete));
    notifyListeners();
  }

  void startEdit() {
    isEdit = true;
    textEditingController.text = comment?.content ?? "";
    notifyListeners();
  }

  void cancelEdit() {
    isEdit = false;
    textEditingController.text = "";
    notifyListeners();
  }

  Future<void> editComment() async {
    if (isWorking == true) return;
    if (textEditingController.text == comment?.content) return;
    try {
      await _repository.editComment(comment_id, textEditingController.text);
      isWorking = true;
    } catch (e) {
      isWorking = false;
      return;
    }
    await Future.delayed(const Duration(milliseconds: 1700));
    comment = await _repository.fetchCommentItem(comment_id);
    isEdit = false;
    isWorking = false;
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
