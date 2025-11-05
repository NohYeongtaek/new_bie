import 'package:flutter/material.dart';
import 'package:new_bie/src/entity/post_entity.dart';
import 'package:new_bie/src/screens/post/post_repository.dart';

class HomeViewModel extends ChangeNotifier {
  //포스트 리포지토리와 연결
  final PostRepository _postRepository;
  List<PostEntity> _posts = [];
  List<PostEntity> get posts => _posts;

  //페이징 처리
  int _currentPage = 1;
  int get currentPage => _currentPage;

  //스크롤 컨트롤러
  ScrollController scrollController = ScrollController();

  HomeViewModel(this._postRepository) {
    fetchPosts();
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

  Future<void> fetchPosts() async {
    _posts = await _postRepository.fetchPosts();
    notifyListeners();
  }

  Future<void> fetchMoreMemos() async {
    _currentPage = currentPage + 1;
    List<PostEntity> newPosts = await _postRepository.fetchPosts();
    _posts.addAll(newPosts);
    notifyListeners();
  }
}
