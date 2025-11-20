import 'package:flutter/material.dart';
import 'package:new_bie/features/follow/data/entity/follow_entity.dart';
import 'package:new_bie/features/follow/data/follow_repository.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';

import '../../../core/models/event_bus/follow_list_event_bus.dart';
import '../../../core/models/managers/supabase_manager.dart';
import '../../../main.dart';

/// 팔로워/팔로잉 목록을 관리하는 ViewModel
class FollowListViewModel extends ChangeNotifier {
  /// 팔로워 유저 리스트 (targetUserId를 팔로우하는 사람들)
  List<FollowEntity?> _followerUsers = [];

  /// 팔로잉 유저 리스트 (targetUserId가 팔로우하는 사람들)
  List<FollowEntity?> _followingUsers = [];
  List<FollowEntity?> get followingUsers => _followingUsers;

  /// 현재 로그인한 사용자의 팔로잉 목록 (isFollowing 체크용)
  List<FollowEntity?> _myFollowingUsers = [];
  List<FollowEntity?> get myFollowingUsers => _myFollowingUsers;

  /// 팔로워 유저 프로필 리스트
  List<UserEntity?> _followerUserProfiles = [];
  List<UserEntity?> get followerUserProfiles => _followerUserProfiles;

  /// 팔로잉 유저 프로필 리스트
  List<UserEntity?> _followingUserProfiles = [];
  List<UserEntity?> get followingUserProfiles => _followingUserProfiles;

  FollowListViewModel(BuildContext context);

  /// 특정 사용자의 팔로워/팔로잉 목록과 프로필을 한 번에 조회
  /// targetUserId가 null이면 현재 로그인한 사용자의 데이터를 조회
  Future<void> fetchAllFollowData({String? targetUserId}) async {
    // 즉시 리스트를 초기화하여 이전 데이터가 표시되지 않도록 함
    // (다른 사용자 프로필로 이동 시 이전 데이터가 깜빡이는 현상 방지)
    _clearLists();
    notifyListeners();

    final currentUser = SupabaseManager.shared.supabase.auth.currentUser!;
    final userId = targetUserId ?? currentUser.id;
    final myId = currentUser.id;

    final allFollowRelations = await FollowRepository.shared.fetchAllFollowRelations(userId);
    _separateFollowLists(allFollowRelations, userId);
    _myFollowingUsers = await FollowRepository.shared.fetchFollowingUsers(myId);

    final allUserIds = _collectUserIds(userId);
    final userProfileMap = await _fetchUserProfilesMap(allUserIds);
    _mapFollowsToProfiles(userId, userProfileMap);

    notifyListeners();
  }

  /// 모든 팔로워/팔로잉 리스트 초기화
  void _clearLists() {
    _followerUsers = [];
    _followingUsers = [];
    _followerUserProfiles = [];
    _followingUserProfiles = [];
  }

  /// 팔로우 관계 리스트를 팔로워/팔로잉으로 분리
  /// following_id가 userId인 경우 → 팔로워
  /// follower_id가 userId인 경우 → 팔로잉
  void _separateFollowLists(List<FollowEntity?> allFollowRelations, String userId) {
    _followerUsers = allFollowRelations
        .where((follow) => follow?.following_id == userId)
        .toList();
    _followingUsers = allFollowRelations
        .where((follow) => follow?.follower_id == userId)
        .toList();
  }

  /// 팔로워/팔로잉 목록에서 사용자 ID 수집 (자기 자신 제외)
  Set<String> _collectUserIds(String userId) {
    return <String>{
      for (final follow in _followerUsers)
        if (follow != null && follow.follower_id != userId) follow.follower_id,
      for (final follow in _followingUsers)
        if (follow != null && follow.following_id != userId) follow.following_id,
    };
  }

  /// 사용자 ID 목록으로 프로필을 일괄 조회하여 Map으로 반환
  Future<Map<String, UserEntity>> _fetchUserProfilesMap(Set<String> userIds) async {
    final profiles = await SupabaseManager.shared.fetchUsersByIds(userIds.toList());
    return {for (final user in profiles) user.id: user};
  }

  /// 팔로우 관계를 프로필 정보로 매핑하여 프로필 리스트 생성
  /// 자기 자신은 제외하고, 프로필이 존재하는 경우에만 추가
  void _mapFollowsToProfiles(String userId, Map<String, UserEntity> userProfileMap) {
    _followerUserProfiles = _followerUsers
        .where((follow) =>
            follow != null &&
            follow.follower_id != userId &&
            userProfileMap.containsKey(follow.follower_id))
        .map((follow) => userProfileMap[follow!.follower_id]!)
        .toList();

    _followingUserProfiles = _followingUsers
        .where((follow) =>
            follow != null &&
            follow.following_id != userId &&
            userProfileMap.containsKey(follow.following_id))
        .map((follow) => userProfileMap[follow!.following_id]!)
        .toList();
  }


  /// 팔로우 관계를 삭제하고 UI 목록에서도 제거
  /// 팔로잉 목록과 팔로워 목록 모두에서 제거하여 즉시 UI 반영
  Future<void> unFollow(int id) async {
    await FollowRepository.shared.deleteFollow(id);

    _myFollowingUsers.removeWhere((follow) => follow?.id == id);

    // 팔로잉 목록에서 제거 (내 팔로잉 목록)
    final targetFollowEntity = _findFollowEntityById(_followingUsers, id);
    if (targetFollowEntity != null) {
      _followingUsers.removeWhere((follow) => follow?.id == id);
      _followingUserProfiles.removeWhere((user) => user?.id == targetFollowEntity.following_id);
    }

    // 팔로워 목록에서도 제거 (다른 사람의 팔로워 목록에 내가 있을 때)
    // 예: 다른 사람의 팔로워 목록에서 내가 언팔로우 버튼을 눌렀을 때
    final currentUser = SupabaseManager.shared.supabase.auth.currentUser!;
    final myId = currentUser.id;
    FollowEntity? followerFollowEntity;
    try {
      followerFollowEntity = _followerUsers.firstWhere(
        (f) => f?.id == id && f?.follower_id == myId,
      );
    } catch (e) {
      followerFollowEntity = null;
    }
    if (followerFollowEntity != null) {
      _followerUsers.removeWhere((follow) => follow?.id == id);
      _followerUserProfiles.removeWhere((user) => user?.id == myId);
    }

    notifyListeners();
    eventBus.fire(
      FollowListEventBus(message: "언팔로우 되었습니다", type: FollowEventType.unFollow),
    );
  }

  /// 팔로우 관계를 추가하고 UI 목록에도 반영
  /// userId가 현재 로그인한 사용자일 경우에만 목록 업데이트
  Future<void> addFollow(String userId, String blockId) async {
    await FollowRepository.shared.addFollow(userId, blockId);

    final myId = SupabaseManager.shared.supabase.auth.currentUser!.id;
    if (userId == myId) {
      await _updateMyFollowingList(myId, blockId);
      notifyListeners();
    }

    eventBus.fire(
      FollowListEventBus(message: "팔로우 되었습니다", type: FollowEventType.addFollow),
    );
  }

  /// 현재 사용자의 팔로잉 목록을 업데이트하고 새로 추가된 팔로우를 목록에 반영
  Future<void> _updateMyFollowingList(String myId, String blockId) async {
    final newFollow = await FollowRepository.shared.fetchFollowingUsers(myId);
    _myFollowingUsers = newFollow;

    final addedFollow = _findFollowEntityByFollowingId(newFollow, blockId);
    if (addedFollow != null && !_followingUsers.any((f) => f?.id == addedFollow.id)) {
      _followingUsers.add(addedFollow);
      final userProfile = await SupabaseManager.shared.fetchUser(blockId);
      if (userProfile != null && !_followingUserProfiles.any((u) => u?.id == blockId)) {
        _followingUserProfiles.add(userProfile);
      }
    }
  }

  /// 팔로우 엔티티 리스트에서 ID로 엔티티 찾기 (없으면 null 반환)
  FollowEntity? _findFollowEntityById(List<FollowEntity?> follows, int id) {
    try {
      return follows.firstWhere((f) => f?.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 팔로우 엔티티 리스트에서 following_id로 엔티티 찾기 (없으면 null 반환)
  FollowEntity? _findFollowEntityByFollowingId(List<FollowEntity?> follows, String followingId) {
    try {
      return follows.firstWhere((f) => f?.following_id == followingId);
    } catch (e) {
      return null;
    }
  }

  /// 현재 로그인한 사용자가 해당 유저를 팔로우하고 있는지 확인
  bool isFollowing(String userId) {
    return _myFollowingUsers.any((follow) => follow?.following_id == userId);
  }
}
