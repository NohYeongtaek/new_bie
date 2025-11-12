import 'package:flutter/material.dart';
import 'package:new_bie/core/models/event_bus/blocked_user_event_bus.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/block_users/data/blocked_user_entity.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';

import '../../../main.dart';

class BlockedUserViewModel extends ChangeNotifier {
  List<BlockedUserEntity?> _blockUsers = [];
  List<BlockedUserEntity?> get blockUsers => _blockUsers;

  List<UserEntity?> _blockedUserProfiles = [];
  List<UserEntity?> get blockedUserProfiles => _blockedUserProfiles;

  BlockedUserViewModel(BuildContext context) {
    fetchBlockedUsers();

    eventBus.on<BlockedUserEvent>().listen((event) {
      switch (event.type) {
        case BlockEventType.blockDelete:
          fetchBlockedUsers();
          break;
      }
    });
  }

  //사용자의 블락리스트를 가져오는 것
  Future<void> fetchBlockedUsers() async {
    final String? userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    if (userId == null) return;
    _blockUsers = await SupabaseManager.shared.fetchBlockUsers(userId);
    notifyListeners();
    await fetchBlockedUserProfile();
    notifyListeners();
  }

  //블락 유저의 프로필을 가져와야함
  Future<void> fetchBlockedUserProfile() async {
    _blockedUserProfiles = [];

    for (var blockUserData in _blockUsers) {
      UserEntity? user = await SupabaseManager.shared.fetchUser(
        blockUserData!.blocked_user_id,
      );
      if (user != null) {
        _blockedUserProfiles.add(user);
        print("user nick_name ${user.nick_name}");
      }
    }
  }

  Future<void> deleteBlockedUser(int id) async {
    await SupabaseManager.shared.deleteBlockUser(id);
    eventBus.fire(
      BlockedUserEvent(message: "차단 해제되었습니다", type: BlockEventType.blockDelete),
    );
  }

  Future<void> addBlockUser(String userId, String blockId) async {
    await SupabaseManager.shared.addBlockUser(userId, blockId);
    await fetchBlockedUsers();
    notifyListeners();
  }
}
