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
    return [
      ..._followerUserProfiles, // 팔로워 목록을 먼저 넣음
      ..._followingUserProfiles, // 그 뒤에 팔로잉 목록을 넣음
    ];
  }

  FollowListViewModel(BuildContext context) {
    fetchAllFollowData();
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

  Future<void> fetchAllFollowData() async {
    await Future.wait([fetchFollowerUsers(), fetchFollowingUsers()]);
    // 모든 엔티티를 가져온 후, 프로필을 가져옵니다.
    await fetchFollowerUserProfile();
    await fetchFollowingUserProfile();
    notifyListeners();
  }

  //나 or 사용자의 팔로워 유저를 가져오는 것
  Future<void> fetchFollowerUsers() async {
    final String? userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    if (userId == null) return;
    _followerUsers = await SupabaseManager.shared.fetchFollowerUsers(userId);
    await fetchFollowerUserProfile();
    notifyListeners();
  }

  //나 or 사용자의 팔로잉 유저를 가져오는 것
  Future<void> fetchFollowingUsers() async {
    final String? userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    if (userId == null) return;
    _followingUsers = await SupabaseManager.shared.fetchFollowingUsers(userId);
    await fetchFollowingUserProfile();
    notifyListeners();
  }

  //팔로워 유저의 프로필을 가져와야함
  Future<void> fetchFollowerUserProfile() async {
    _followerUserProfiles = [];

    for (var followerUserData in _followerUsers) {
      UserEntity? user = await SupabaseManager.shared.fetchUser(
        followerUserData!.follower_id,
      );
      if (user != null) {
        _followerUserProfiles.add(user);
        print("followUser nick_name ${user.nick_name}");
      }
    }
  }

  //팔로잉 유저의 프로필을 가져와야함
  Future<void> fetchFollowingUserProfile() async {
    _followingUserProfiles = [];

    for (var followingUserData in _followingUsers) {
      UserEntity? user = await SupabaseManager.shared.fetchUser(
        followingUserData!.following_id,
      );
      if (user != null) {
        _followingUserProfiles.add(user);
        print("followingUser nick_name ${user.nick_name}");
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
