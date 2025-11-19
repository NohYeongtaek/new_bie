import 'package:flutter/material.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/comment_with_profile_entity.dart';
import 'package:new_bie/features/post/data/post_repository.dart';
import 'package:provider/provider.dart';

class CommentsViewmodel extends ChangeNotifier {
  // int inputCount = 0;
  final PostRepository _repository;

  final TextEditingController textEditingController = TextEditingController();
  final int postId;
  // List<int> commentsIdList = [];
  int? selectCommentIndex;
  bool isWorking = false;
  final TextEditingController commentUpdatingController =
      TextEditingController();
  List<CommentWithProfileEntity> commentsList = [];

  // 뷰모델 생성자, context를 통해 리포지토리를 받아올 수 있음.
  CommentsViewmodel(this.postId, BuildContext context)
    : _repository = context.read<PostRepository>() {
    // fetchCommentsId();
    fetchComment();
    // eventBus.on<CommentEvent>().listen((event) {
    //   switch (event.type) {
    //     case CommentEventType.commentDelete:
    //       refreshCommentsId();
    //       break;
    //   }
    // });
  }
  Future<void> fetchComment() async {
    isWorking = true;
    commentsList = await _repository.fetchComments(postId);
    isWorking = false;
    notifyListeners();
  }

  void startEdit(int index) {
    selectCommentIndex = index;
    commentUpdatingController.text = commentsList[index].content ?? "";
    notifyListeners();
  }

  void cancelEdit() {
    selectCommentIndex = null;
    commentUpdatingController.text = "";
    notifyListeners();
  }

  Future<void> editComment(int index, int commentId) async {
    if (isWorking == true) return;
    if (commentUpdatingController.text == commentsList[index].content) return;
    try {
      await _repository.editComment(commentId, commentUpdatingController.text);
      isWorking = true;
    } catch (e) {
      isWorking = false;
      return;
    }
    commentsList[index].content = commentUpdatingController.text;
    selectCommentIndex = null;
    notifyListeners();
    commentsList[index] = await _repository.fetchCommentItem(commentId);
    commentUpdatingController.text = "";
    isWorking = false;
    notifyListeners();
  }

  // Future<void> fetchCommentsId() async {
  //   commentsIdList = await _repository.fetchCommentIds(postId);
  //   notifyListeners();
  // }
  //
  // Future<void> refreshCommentsId() async {
  //   commentsIdList = [];
  //   commentsIdList = await _repository.fetchCommentIds(postId);
  //   notifyListeners();
  // }

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
    commentsList = await _repository.fetchComments(postId);
    notifyListeners();
  }

  Future<void> deleteComment(int index, int comment_id) async {
    await _repository.deleteComment(comment_id);
    commentsList.removeAt(index);
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
