import 'package:flutter/material.dart';
import 'package:new_bie/features/follow/data/entity/follow_entity.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';

import '../../../core/models/event_bus/follow_list_event_bus.dart';
import '../../../core/models/managers/supabase_manager.dart';
import '../../../main.dart';

class FollowListViewModel extends ChangeNotifier {
  // 팔로워 유저 리스트 그릇
  List<FollowEntity?> _followerUsers = [];
  List<FollowEntity?> get followerUsers => _followerUsers;

  // 팔로잉 유저 리스트 그릇
  List<FollowEntity?> _followingUsers = [];
  List<FollowEntity?> get followingUsers => _followingUsers;

  // 팔로워 유저 프로필 리스트 그릇
  List<UserEntity?> _followerUserProfiles = [];
  List<UserEntity?> get followerUserProfiles => _followerUserProfiles;

  // 팔로잉 유저 프로필 리스트 그릇
  List<UserEntity?> _followingUserProfiles = [];
  List<UserEntity?> get followingUserProfiles => _followingUserProfiles;

  List<UserEntity?> get allUserProfiles {
    final Map<String, UserEntity> uniqueUsers = {};

    for (var user in _followerUserProfiles) {
      if (user != null) uniqueUsers[user.id] = user; // 팔로워 우선
    }

    for (var user in _followingUserProfiles) {
      if (user != null && !uniqueUsers.containsKey(user.id)) {
        uniqueUsers[user.id] = user; // 팔로잉 중 중복 제거
      }
    }

    return uniqueUsers.values.toList();
  }

  FollowListViewModel(BuildContext context) {
    // fetchAllFollowData();
    // eventBus.on<FollowListEventBus>().listen((event) {
    //   switch (event.type) {
    //     case FollowEventType.unFollow:
    //       fetchAllFollowData();
    //       break;
    //     case FollowEventType.addFollow:
    //       fetchAllFollowData();
    //       break;
    //   }
    // });
  }

  Future<void> fetchAllFollowData({String? targetUserId}) async {
    // 0. 기존 리스트 초기화
    _followerUsers = [];
    _followingUsers = [];
    _followerUserProfiles = [];
    _followingUserProfiles = [];

    // targetUserId가 없으면 현재 로그인 유저 ID를 사용
    final String userId =
        targetUserId ?? SupabaseManager.shared.supabase.auth.currentUser!.id;

    // 1. 팔로워/팔로잉 목록 엔티티 가져오기
    await Future.wait([
      SupabaseManager.shared
          .fetchFollowerUsers(userId)
          .then((data) => _followerUsers = data),
      SupabaseManager.shared
          .fetchFollowingUsers(userId)
          .then((data) => _followingUsers = data),
    ]);

    // 2. 프로필 정보 가져오기 (자기 자신 제외)
    await fetchFollowerUserProfile(targetUserId: targetUserId);
    await fetchFollowingUserProfile(targetUserId: targetUserId);

    // 3. UI 갱신
    notifyListeners();
  }

  //팔로워 유저의 프로필을 가져와야함
  Future<void> fetchFollowerUserProfile({String? targetUserId}) async {
    _followerUserProfiles = [];

    final excludedUserId =
        targetUserId ?? SupabaseManager.shared.supabase.auth.currentUser!.id;

    for (var followerUserData in _followerUsers) {
      if (followerUserData == null) continue;

      // targetUserId 본인은 제외
      if (followerUserData.follower_id == excludedUserId) continue;

      UserEntity? user = await SupabaseManager.shared.fetchUser(
        followerUserData.follower_id,
      );
      if (user != null) {
        _followerUserProfiles.add(user);
      }
    }
  }

  //팔로잉 유저의 프로필을 가져와야함
  Future<void> fetchFollowingUserProfile({String? targetUserId}) async {
    _followingUserProfiles = [];

    final excludedUserId =
        targetUserId ?? SupabaseManager.shared.supabase.auth.currentUser!.id;

    for (var followingUserData in _followingUsers) {
      if (followingUserData == null) continue;

      // targetUserId 본인은 제외
      if (followingUserData.following_id == excludedUserId) continue;

      UserEntity? user = await SupabaseManager.shared.fetchUser(
        followingUserData.following_id,
      );
      if (user != null) {
        _followingUserProfiles.add(user);
      }
    }
  }

  Future<void> unFollow(int id) async {
    // 1. DB에서 삭제
    await SupabaseManager.shared.deleteFollow(id);

    // await fetchAllFollowData();₩ㅌ

    // (다른 화면 갱신이 필요하다면 이벤트 버스 유지)
    eventBus.fire(
      FollowListEventBus(message: "언팔로우 되었습니다", type: FollowEventType.unFollow),
    );
  }

  Future<void> addFollow(String userId, String blockId) async {
    // 1. DB에 추가
    await SupabaseManager.shared.addFollow(userId, blockId);

    // await fetchAllFollowData();
    // (다른 화면 갱신이 필요하다면 이벤트 버스 유지)
    eventBus.fire(
      FollowListEventBus(message: "팔로우 되었습니다", type: FollowEventType.addFollow),
    );
  }

  bool isFollowing(String userId) {
    return _followingUsers.any((follow) => follow?.following_id == userId);
  }
}
