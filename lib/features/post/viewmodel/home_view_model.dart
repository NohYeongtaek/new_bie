import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/post_repository.dart';
import 'package:new_bie/main.dart';

enum OrderByType { newFirst, oldFirst, likesFirst }

class HomeViewModel extends ChangeNotifier {
  //포스트 리포지토리와 연결
  final PostRepository _postRepository;
  List<PostWithProfileEntity> _posts = [];
  List<PostWithProfileEntity> get posts => _posts;
  bool buttonIsWorking = false;
  OrderByType type = OrderByType.newFirst;
  //페이징 처리
  int _currentPage = 1;
  int get currentPage => _currentPage;
  String selectCategory = "전체";
  List<String> categoryList = ["전체"];
  //스크롤 컨트롤러
  ScrollController scrollController = ScrollController();

  HomeViewModel(this._postRepository) {
    getCategoryList();
    Timer? _debounce;

    scrollController.addListener(() async {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 300), () {
        final double offset = scrollController.offset;

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

      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        fetchNextPosts();
      }
    });
    fetchPosts();
  }
  void upToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  String setOrderBy(OrderByType type) {
    if (type == OrderByType.newFirst)
      return "created_at.desc";
    else if (type == OrderByType.oldFirst)
      return "created_at.asc";
    else
      return "likes_count.desc";
  }

  Future<void> fetchPosts() async {
    String orderBy = setOrderBy(type);
    _posts = await _postRepository.fetchPosts(
      orderBy,
      currentIndex: _currentPage,
      category: selectCategory,
    );
    notifyListeners();
  }

  Future<void> fetchNextPosts() async {
    _currentPage++;
    String orderBy = setOrderBy(type);
    List<PostWithProfileEntity> newFetchPosts = await _postRepository
        .fetchPosts(
          orderBy,
          currentIndex: _currentPage,
          category: selectCategory,
        );
    _posts.addAll(newFetchPosts);
    notifyListeners();
  }

  Future<void> handleRefresh() async {
    String userId = supabase.auth.currentUser?.id ?? "null1";
    _currentPage = 1;
    _posts = [];
    notifyListeners();
    String orderBy = setOrderBy(type);
    _posts = await _postRepository.fetchPosts(
      orderBy,
      currentIndex: _currentPage,
      category: selectCategory,
    );
    notifyListeners();
  }

  // Future<void> fetchMoreMemos() async {
  //   _currentPage = currentPage + 1;
  //   List<PostWithProfileEntity> newPosts = await _postRepository.fetchPosts();
  //   _posts.addAll(newPosts);
  //   notifyListeners();
  // }

  void likeCountUp(int index) {}

  Future<void> ChangeOrder(OrderByType inputType) async {
    type = inputType;
    await handleRefresh();
    notifyListeners();
  }

  Future<void> getCategoryList() async {
    categoryList.addAll(await _postRepository.getCategoryList());
    print("${categoryList}");
    notifyListeners();
  }

  Future<void> ChangeCategory(String category) async {
    selectCategory = category;
    await handleRefresh();
    notifyListeners();
  }
}
