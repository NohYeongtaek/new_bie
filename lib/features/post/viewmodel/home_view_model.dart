import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_bie/core/models/event_bus/like_event_bus.dart';
import 'package:new_bie/core/models/event_bus/post_event_bus.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/post_repository.dart';
import 'package:new_bie/main.dart';

enum OrderByType { newFirst, oldFirst, likesFirst }

class HomeViewModel extends ChangeNotifier {
  //포스트 리포지토리와 연결
  static const PageType pageType = PageType.home;
  final PostRepository _postRepository;
  final keywordController = TextEditingController();
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
  StreamSubscription? _postSubscription;
  StreamSubscription? _likeSubscription;

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
    _postSubscription = eventBus.on<PostEventBus>().listen((event) async {
      switch (event.type) {
        case PostEventType.add:
          Refresh();
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
            final newPost = await _postRepository.fetchPostItem(
              event.postId ?? 0,
            );
            posts[postIndex] = newPost;
            notifyListeners();
          }
          break;
      }
    });
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

  Future<void> Refresh() async {
    type = OrderByType.newFirst;
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

  Future<void> deletePost(int postId) async {
    final index = posts.indexWhere((item) => item.id == postId);
    await _postRepository.deletePost(postId);
    posts.removeAt(index);
    notifyListeners();
  }

  void keywordReset() {
    keywordController.text = "";
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
        await _postRepository.insertLike(postId, userId);
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
        await _postRepository.cancelLike(postId, userId);
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
}
