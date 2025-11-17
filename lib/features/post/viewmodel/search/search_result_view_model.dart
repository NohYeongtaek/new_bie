import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/search_result_entity.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';
import 'package:new_bie/features/post/data/post_repository.dart';
import 'package:provider/provider.dart';

class SearchResultViewModel extends ChangeNotifier {
  // int inputCount = 0;

  // final TextEditingController textEditingController = TextEditingController();

  // 뷰모델 생성자, context를 통해 리포지토리를 받아올 수 있음.
  List<UserEntity> users = [];
  List<PostWithProfileEntity> posts = [];
  SearchResultEntity? searchResult;
  PostRepository _repository;
  bool buttonIsWorking = false;
  final keywordController = TextEditingController();
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
