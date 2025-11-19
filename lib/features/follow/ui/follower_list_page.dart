import 'package:flutter/material.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/follow/data/entity/follow_entity.dart';
import 'package:new_bie/features/follow/viewmodel/follow_list_view_model.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';
import 'package:new_bie/features/post/ui/components/profile/small_profile_component.dart';
import 'package:provider/provider.dart';

class FollowerListPage extends StatelessWidget {
  final int initialTabIndex;
  final String targetUserId;
  const FollowerListPage({
    super.key,
    required this.initialTabIndex,
    required this.targetUserId,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FollowListViewModel>();
    Future.microtask(
      () => viewModel.fetchAllFollowData(targetUserId: targetUserId),
    );
    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
            future: SupabaseManager.shared.fetchUser(targetUserId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("");
              }
              final user = snapshot.data!;
              return Text(user.nick_name ?? "알 수 없음");
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: false,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: '팔로워'),
              Tab(text: '팔로잉'),
            ],
            indicatorColor: orangeColor,
            labelColor: orangeColor,
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        body: SafeArea(
          child: Consumer<FollowListViewModel>(
            builder: (context, viewModel, child) {
              return TabBarView(
                children: [
                  ListView.builder(
                    itemCount: viewModel.followerUserProfiles.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      final UserEntity user =
                          viewModel.followerUserProfiles[index]!;
                      final isFollowing = viewModel.isFollowing(user.id);

                      return SizedBox(
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SmallProfileComponent(
                                imageUrl: viewModel
                                    .followerUserProfiles[index]
                                    ?.profile_image,
                                nickName:
                                    viewModel
                                        .followerUserProfiles[index]
                                        ?.nick_name ??
                                    '',
                                introduce:
                                    viewModel
                                        .followerUserProfiles[index]
                                        ?.introduction ??
                                    '',
                                userId: user.id,
                              ),
                            ),
                            if (user.id !=
                                SupabaseManager
                                    .shared
                                    .supabase
                                    .auth
                                    .currentUser
                                    ?.id)
                              FollowButton(
                                userProfile: user,
                                isInitialFollowing: isFollowing,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: viewModel.followingUserProfiles.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      final UserEntity user =
                          viewModel.followingUserProfiles[index]!;
                      final FollowEntity follow = viewModel.followingUsers
                          .firstWhere((f) => f?.following_id == user.id)!;

                      return SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: SmallProfileComponent(
                                imageUrl: viewModel
                                    .followingUserProfiles[index]
                                    ?.profile_image,
                                nickName:
                                    viewModel
                                        .followingUserProfiles[index]
                                        ?.nick_name ??
                                    '',
                                introduce:
                                    viewModel
                                        .followingUserProfiles[index]
                                        ?.introduction ??
                                    '',
                                userId: user.id,
                              ),
                            ),
                            if (user.id !=
                                SupabaseManager
                                    .shared
                                    .supabase
                                    .auth
                                    .currentUser
                                    ?.id)
                              FollowButton(
                                userProfile: user,
                                isInitialFollowing: true,
                                followEntity: follow,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FollowButton extends StatefulWidget {
  final UserEntity userProfile; // 해당 유저 프로필
  final FollowEntity? followEntity; // 팔로잉 관계 엔티티 (언팔로우 시 필요)
  final bool
  isInitialFollowing; // 초기 팔로우 상태  const FollowButton({super.key, required this.index});

  const FollowButton({
    super.key,
    required this.userProfile,
    this.followEntity,
    required this.isInitialFollowing,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    isFollowing = widget.isInitialFollowing; // 전달받은 초기 상태 사용
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FollowListViewModel>();
    final myId = SupabaseManager.shared.supabase.auth.currentUser!.id;

    return TextButton(
      onPressed: () async {
        // 1) UI 즉시 토글 (인스타처럼)
        setState(() {
          isFollowing = !isFollowing;
        });

        // 2) DB 업데이트
        if (isFollowing) {
          // 팔로우
          await viewModel.addFollow(myId, widget.userProfile.id);
        } else {
          // 언팔로우 (followEntity가 null일 수 있으므로 주의)
          final targetFollowEntity =
              widget.followEntity ??
              viewModel.followingUsers.firstWhere(
                (f) => f!.following_id == widget.userProfile.id,
                orElse: () => null, // 찾지 못하면 null 반환
              );

          if (targetFollowEntity != null) {
            await viewModel.unFollow(targetFollowEntity.id);
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
