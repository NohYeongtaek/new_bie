import 'package:flutter/material.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/follow/data/entity/follow_entity.dart';
import 'package:new_bie/features/follow/viewmodel/follow_list_view_model.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';
import 'package:provider/provider.dart';

// 팔로잉 목록용 버튼 (언팔로우만)
class FollowingUnfollowButton extends StatelessWidget {
  final UserEntity userProfile; // 해당 유저 프로필
  final FollowEntity? followEntity; // 팔로잉 관계 엔티티 (언팔로우 시 필요)

  const FollowingUnfollowButton({
    super.key,
    required this.userProfile,
    this.followEntity,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FollowListViewModel>();

    return TextButton(
      onPressed: () async {
        // 언팔로우만 가능
        FollowEntity? targetFollowEntity = followEntity;

        if (targetFollowEntity == null) {
          try {
            targetFollowEntity = viewModel.followingUsers.firstWhere(
              (f) => f?.following_id == userProfile.id,
            );
          } catch (e) {
            targetFollowEntity = null;
          }
        }

        if (targetFollowEntity != null) {
          await viewModel.unFollow(targetFollowEntity.id);
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey.shade100,
        foregroundColor: blackColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: const Text("팔로잉", style: TextStyle(fontSize: 14)),
    );
  }
}
