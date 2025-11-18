import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_bie/core/models/event_bus/like_event_bus.dart';
import 'package:new_bie/core/models/event_bus/post_event_bus.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/search_result_entity.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';
import 'package:new_bie/features/post/data/post_repository.dart';
import 'package:new_bie/main.dart';
import 'package:provider/provider.dart';

class SearchResultViewModel extends ChangeNotifier {
  // int inputCount = 0;

  // final TextEditingController textEditingController = TextEditingController();

  // 뷰모델 생성자, context를 통해 리포지토리를 받아올 수 있음.
  static const PageType pageType = PageType.search;
  List<UserEntity> users = [];
  List<PostWithProfileEntity> posts = [];
  SearchResultEntity? searchResult;
  PostRepository _repository;
  bool buttonIsWorking = false;
  final keywordController = TextEditingController();
  StreamSubscription? _postSubscription;
  StreamSubscription? _likeSubscription;
  SearchResultViewModel(BuildContext context)
    : _repository = context.read<PostRepository>() {
    Timer? _debounce;

    userScrollController.addListener(() async {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 300), () {
        final double offset = userScrollController.offset;

        if (offset < 50) {
          if (buttonIsWorking) {
            buttonIsWorking = false;
            notifyListeners();
          }
        } else {
          if (!buttonIsWorking) {
            buttonIsWorking = true;
            notifyListeners();
          }
        }
      });

      if (userScrollController.offset ==
          userScrollController.position.maxScrollExtent) {
        fetchMoreUser();
      }
    });
    _postSubscription = eventBus.on<PostEventBus>().listen((event) async {
      switch (event.type) {
        case PostEventType.add:
          break;
        case PostEventType.delete:
          final exists = posts.any((post) => post.id == event.postId);
          if (exists) {
            final foundPost = posts.indexWhere(
              (post) => post.id == event.postId,
            );
            posts.removeAt(foundPost);
            notifyListeners();
          }
          break;
        case PostEventType.edit:
          final exists = posts.any((post) => post.id == event.postId);
          if (exists) {
            final postIndex = posts.indexWhere(
              (post) => post.id == event.postId,
            );
            final newPost = await _repository.fetchPostItem(event.postId ?? 0);
            posts[postIndex] = newPost;
            notifyListeners();
          }
          break;
      }
    });
    _likeSubscription = eventBus.on<LikeEventBus>().listen((event) async {
      if (event.pageType != pageType) {
        switch (event.type) {
          case LikeActionType.like:
            final exists = posts.any((post) => post.id == event.postId);
            if (exists) {
              final foundPost = posts.indexWhere(
                (post) => post.id == event.postId,
              );
              posts[foundPost].likes_count++;
              posts[foundPost].isLiked = true;
              notifyListeners();
            }
            break;
          case LikeActionType.cancel:
            final exists = posts.any((post) => post.id == event.postId);
            if (exists) {
              final foundPost = posts.indexWhere(
                (post) => post.id == event.postId,
              );
              posts[foundPost].likes_count--;
              posts[foundPost].isLiked = false;
              notifyListeners();
            }
            break;
        }
      }
    });
    postScrollController.addListener(() async {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 300), () {
        final double offset = postScrollController.offset;

        if (offset < 50) {
          if (buttonIsWorking) {
            buttonIsWorking = false;
            notifyListeners();
          }
        } else {
          if (!buttonIsWorking) {
            buttonIsWorking = true;
            notifyListeners();
          }
        }
      });

      if (postScrollController.offset ==
          postScrollController.position.maxScrollExtent) {
        fetchMorePost();
      }
    });
  }
  int _userCurrentPage = 1;
  int get userCurrentPage => _userCurrentPage;

  int _postCurrentPage = 1;
  int get postCurrentPage => _postCurrentPage;

  ScrollController userScrollController = ScrollController();
  ScrollController postScrollController = ScrollController();

  late TabController tabController;

  void initializeTabController(TickerProvider tickerProvider) {
    tabController = TabController(length: 3, vsync: tickerProvider);

    // 탭 변경 시 상태 업데이트
    tabController.addListener(() {
      notifyListeners();
    });
  }

  // 특정 탭으로 이동
  void moveToTab(int index) {
    tabController.animateTo(index);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // 홈화면에서 검색
  Future<void> search(String keyword) async {
    posts = [];
    users = [];
    _userCurrentPage = 1;
    _postCurrentPage = 1;
    keywordController.text = keyword;
    searchResult = await _repository.searchAll(keyword);
    posts = searchResult?.posts ?? [];
    users = searchResult?.users ?? [];
    notifyListeners();
  }

  // 검색결과 페이지에서 검색
  Future<void> searchAtResultPage() async {
    posts = [];
    users = [];
    _userCurrentPage = 1;
    _postCurrentPage = 1;
    searchResult = await _repository.searchAll(keywordController.text);
    posts = searchResult?.posts ?? [];
    users = searchResult?.users ?? [];
    notifyListeners();
  }

  // 유저 더 가져오기
  Future<void> fetchMoreUser() async {
    _userCurrentPage++;
    searchResult = await _repository.searchAll(
      keywordController.text,
      type: "user",
      currentIndex: _userCurrentPage,
    );
    users.addAll(searchResult?.users ?? []);
    notifyListeners();
  }

  // 유저 리스트 새로고침
  Future<void> refreshUserPage() async {
    _userCurrentPage = 1;
    searchResult = await _repository.searchAll(
      keywordController.text,
      type: "user",
      currentIndex: _userCurrentPage,
    );
    users = searchResult?.users ?? [];
    notifyListeners();
  }

  // 게시물 더 가져오기
  Future<void> fetchMorePost() async {
    _postCurrentPage++;
    searchResult = await _repository.searchAll(
      keywordController.text,
      type: "post",
      currentIndex: _postCurrentPage,
    );
    posts.addAll(searchResult?.posts ?? []);
    notifyListeners();
  }

  // 게시물 리스트 새로고침
  Future<void> refreshPostPage() async {
    _postCurrentPage = 1;
    searchResult = await _repository.searchAll(
      keywordController.text,
      type: "post",
      currentIndex: _postCurrentPage,
    );
    posts = searchResult?.posts ?? [];
    notifyListeners();
  }

  Future<void> deletePost(int postId) async {
    final index = posts.indexWhere((item) => item.id == postId);
    await _repository.deletePost(postId);
    posts.removeAt(index);
    notifyListeners();
  }

  Future<void> likeToggle(int index, int postId) async {
    String? userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    bool isDone = false;
    late LikeActionType type;
    if (userId == null) return;
    if (posts[index].isLiked == false) {
      type = LikeActionType.like;
      try {
        posts[index].isLiked = true;
        posts[index].likes_count++;
        notifyListeners();
        await _repository.insertLike(postId, userId);
        isDone = true;
      } catch (e) {
        print("좋아요 실패 : ${e}");
        posts[index].isLiked = false;
        posts[index].likes_count--;
        notifyListeners();
        isDone = false;
      }
    } else if (posts[index].isLiked == true) {
      type = LikeActionType.cancel;
      try {
        posts[index].isLiked = false;
        posts[index].likes_count--;
        notifyListeners();
        await _repository.cancelLike(postId, userId);
        isDone = true;
      } catch (e) {
        print("좋아요 취소 실패 : ${e}");
        posts[index].isLiked = true;
        posts[index].likes_count++;
        notifyListeners();
        isDone = false;
      }
    }
    if (isDone) {
      eventBus.fire(LikeEventBus(pageType, type, posts[index].id));
    }
    // posts[index] = await _postRepository.fetchPostItem(postId);
    // notifyListeners();
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
