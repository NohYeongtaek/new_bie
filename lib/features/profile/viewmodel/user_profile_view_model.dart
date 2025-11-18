import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_bie/core/models/managers/network_api_manager.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';

class UserProfileViewModel extends ChangeNotifier {
  final String userId;
  UserEntity? _user;
  bool _isLoading = false;
  ScrollController scrollController = ScrollController();
  int _currentPage = 1;
  int get currentPage => _currentPage;
  bool buttonIsWorking = false;

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;

  List<PostWithProfileEntity> posts = [];

  UserProfileViewModel(this.userId, BuildContext context) {
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
        fetchMorePosts();
        notifyListeners();
      }
    });
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    _user = await SupabaseManager.shared.fetchUser(userId);
    posts = await NetworkApiManager.shared.fetchUserPosts(
      userId,
      currentIndex: currentPage,
    );
    notifyListeners();
  }

  Future<void> fetchMorePosts() async {
    _currentPage++;

    posts.addAll(
      await NetworkApiManager.shared.fetchUserPosts(
        userId,
        currentIndex: currentPage,
      ),
    );
    notifyListeners();
  }

  Future<void> refreshPosts() async {
    _currentPage = 0;
    posts.addAll(
      await NetworkApiManager.shared.fetchUserPosts(
        userId,
        currentIndex: currentPage,
      ),
    );
    notifyListeners();
  }

  // // 특정 유저 프로필 불러오기
  // Future<void> loadUserProfile(String userId) async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     final data = await supabase
  //         .from('users')
  //         .select()
  //         .eq('id', userId)
  //         .single(); // execute 제거
  //
  //     _user = User.fromMap(data as Map<String, dynamic>);
  //   } catch (e) {
  //     debugPrint('유저 정보 로드 실패: $e');
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
