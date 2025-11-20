import 'package:flutter/material.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/follow/data/entity/follow_entity.dart';
import 'package:new_bie/features/follow/ui/components/follower_follow_button.dart';
import 'package:new_bie/features/follow/ui/components/following_unfollow_button.dart';
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
    // 각 페이지마다 독립적인 ViewModel 인스턴스 사용
    // 위젯이 재사용되더라도 새로운 ViewModel 인스턴스가 생성되므로
    // 네비게이션 백으로 돌아와도 이전 데이터가 남아있지 않음
    // (전역 Provider 대신 로컬 Provider 사용)
    return ChangeNotifierProvider(
      create: (context) => FollowListViewModel(context),
      child: _FollowerListContent(
        targetUserId: targetUserId,
        initialTabIndex: initialTabIndex,
      ),
    );
  }
}

// ViewModel을 사용하는 실제 콘텐츠 위젯
class _FollowerListContent extends StatefulWidget {
  final String targetUserId;
  final int initialTabIndex;

  const _FollowerListContent({
    required this.targetUserId,
    required this.initialTabIndex,
  });

  @override
  State<_FollowerListContent> createState() => _FollowerListContentState();
}

class _FollowerListContentState extends State<_FollowerListContent> {
  @override
  void initState() {
    super.initState();
    // ViewModel이 생성된 후 데이터 로드
    // Future.microtask를 사용하여 build가 완료된 후 실행
    Future.microtask(() {
      final viewModel = context.read<FollowListViewModel>();
      viewModel.fetchAllFollowData(targetUserId: widget.targetUserId);
    });
  }

  @override
  void didUpdateWidget(_FollowerListContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // targetUserId가 변경된 경우에만 데이터 갱신
    // (다른 사용자 프로필로 이동한 경우)
    if (oldWidget.targetUserId != widget.targetUserId) {
      final viewModel = context.read<FollowListViewModel>();
      viewModel.fetchAllFollowData(targetUserId: widget.targetUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
            future: SupabaseManager.shared.fetchUser(widget.targetUserId),
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
                      final myId = SupabaseManager.shared.supabase.auth.currentUser?.id;
                      final isMe = user.id == myId;
                      final isFollowing = viewModel.isFollowing(user.id);

                      // 팔로워 목록에서 내가 나올 때는 언팔로우 버튼 표시
                      // (다른 사람의 팔로워 목록에 내가 있다 = 내가 그 사람을 팔로우하고 있다)
                      FollowEntity? myFollowEntity;
                      if (isMe) {
                        try {
                          myFollowEntity = viewModel.myFollowingUsers.firstWhere(
                            (f) => f?.following_id == widget.targetUserId,
                          );
                        } catch (e) {
                          myFollowEntity = null;
                        }
                      }

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
                                // 내 프로필일 때는 클릭 불가 (이동 방지)
                                userId: isMe ? null : user.id,
                              ),
                            ),
                            if (isMe)
                              // 팔로워 목록에서 내가 나올 때는 언팔로우 버튼
                              FollowingUnfollowButton(
                                userProfile: user,
                                followEntity: myFollowEntity,
                              )
                            else
                              // 다른 사람은 팔로우/팔로잉 버튼
                              FollowerFollowButton(
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
                      final myId = SupabaseManager.shared.supabase.auth.currentUser?.id;
                      FollowEntity? follow;
                      try {
                        follow = viewModel.followingUsers
                            .firstWhere((f) => f?.following_id == user.id);
                      } catch (e) {
                        follow = null;
                      }

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
                                // 내 프로필일 때는 클릭 불가 (이동 방지)
                                userId: user.id == myId ? null : user.id,
                              ),
                            ),
                            if (user.id !=
                                SupabaseManager
                                    .shared
                                    .supabase
                                    .auth
                                    .currentUser
                                    ?.id)
                              FollowingUnfollowButton(
                                userProfile: user,
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
