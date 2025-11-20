import 'package:flutter/material.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/follow/viewmodel/follow_list_view_model.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';
import 'package:provider/provider.dart';

// 팔로워 목록용 버튼 (맞팔로우/팔로우)
class FollowerFollowButton extends StatefulWidget {
  final UserEntity userProfile; // 해당 유저 프로필
  final bool isInitialFollowing; // 초기 팔로우 상태

  const FollowerFollowButton({
    super.key,
    required this.userProfile,
    required this.isInitialFollowing,
  });

  @override
  State<FollowerFollowButton> createState() => _FollowerFollowButtonState();
}

class _FollowerFollowButtonState extends State<FollowerFollowButton> {
  bool? _localFollowingState; // 로컬 상태 (null이면 viewModel 상태 사용)

  @override
  void didUpdateWidget(FollowerFollowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // isInitialFollowing이 변경되면 로컬 상태 초기화
    if (oldWidget.isInitialFollowing != widget.isInitialFollowing) {
      _localFollowingState = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FollowListViewModel>();
    final myId = SupabaseManager.shared.supabase.auth.currentUser!.id;
    
    // 로컬 상태가 있으면 사용, 없으면 viewModel 상태 사용
    final isFollowing = _localFollowingState ?? viewModel.isFollowing(widget.userProfile.id);

    return TextButton(
      onPressed: () async {
        final newState = !isFollowing;
        
        // 1) UI 즉시 토글 (인스타처럼)
        setState(() {
          _localFollowingState = newState;
        });

        // 2) DB 업데이트
        if (newState) {
          // 팔로우 (중복 체크)
          if (!viewModel.isFollowing(widget.userProfile.id)) {
            await viewModel.addFollow(myId, widget.userProfile.id);
          }
        } else {
          // 언팔로우
          try {
            final targetFollowEntity = viewModel.myFollowingUsers.firstWhere(
              (f) => f?.following_id == widget.userProfile.id,
            );
            await viewModel.unFollow(targetFollowEntity!.id);
          } catch (e) {
            // 찾지 못한 경우 무시
          }
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: isFollowing ? Colors.grey.shade100 : orangeColor,
        foregroundColor: isFollowing ? blackColor : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        isFollowing ? "팔로잉" : "팔로우",
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

