import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_bie/core/models/event_bus/like_event_bus.dart';
import 'package:new_bie/core/models/event_bus/post_event_bus.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/post_repository.dart';
import 'package:new_bie/main.dart';
import 'package:provider/provider.dart';

class PostDetailViewModel extends ChangeNotifier {
  // int inputCount = 0;

  // final TextEditingController textEditingController = TextEditingController();

  // 뷰모델 생성자, context를 통해 리포지토리를 받아올 수 있음.
  static const PageType pageType = PageType.postDetail;
  final PageController pageController = PageController();
  List<String> images = [];
  int currentPage = 0;
  PostWithProfileEntity? post;
  StreamSubscription? _postSubscription;
  bool isLike = false;
  final int postId;
  PostRepository _repository;

  PostDetailViewModel(this.postId, BuildContext context)
    : _repository = context.read<PostRepository>() {
    fetchPost();
    _postSubscription = eventBus.on<PostEventBus>().listen((event) {
      switch (event.type) {
        case PostEventType.add:
          break;
        case PostEventType.delete:
          break;
        case PostEventType.edit:
          fetchPost();
          break;
      }
    });
  }

  Future<void> fetchPost() async {
    try {
      post = await _repository.fetchPostItem(postId);
    } catch (e) {
      print("에러 : ${e}");
    }
    if (post?.postImages.length != 0) {
      images = post?.postImages.map((it) => it.image_url).toList() ?? [];
    }
    // 리빌딩, 리콤포지션 진행
    notifyListeners();
  }

  void onChangedPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<bool> deletePost() async {
    if (post?.user != SupabaseManager.shared.supabase.auth.currentUser?.id)
      return false;
    try {
      await _repository.deletePost(postId);
    } catch (e) {
      print("삭제에 실패했습니다 : ${e}");
      return false;
    }
    eventBus.fire(PostEventBus(PostEventType.delete, postId: postId));
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

  Future<void> function1() async {
    // 시간 지연 코드
    await Future.delayed(const Duration(milliseconds: 1700));
    notifyListeners();
  }

  Future<void> likeToggle(int postId) async {
    String? userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    bool isDone = false;
    late LikeActionType type;
    if (userId == null) return;
    if (post?.isLiked == false) {
      type = LikeActionType.like;
      try {
        post?.isLiked = true;
        post?.likes_count++;
        notifyListeners();
        await _repository.insertLike(postId, userId);
        isDone = true;
      } catch (e) {
        print("좋아요 실패 : ${e}");
        post?.isLiked = false;
        post?.likes_count--;
        notifyListeners();
        isDone = false;
      }
    } else if (post?.isLiked == true) {
      type = LikeActionType.cancel;
      try {
        post?.isLiked = false;
        post?.likes_count--;
        notifyListeners();
        await _repository.cancelLike(postId, userId);
        isDone = true;
      } catch (e) {
        print("좋아요 취소 실패 : ${e}");
        post?.isLiked = true;
        post?.likes_count++;
        notifyListeners();
        isDone = false;
      }
    }
    if (isDone) {
      eventBus.fire(LikeEventBus(pageType, type, postId));
    }
    // posts[index] = await _postRepository.fetchPostItem(postId);
    // notifyListeners();
  }
}
