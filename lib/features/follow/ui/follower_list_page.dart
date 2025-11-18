import 'package:flutter/material.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/follow/viewmodel/follow_list_view_model.dart';
import 'package:new_bie/features/post/ui/components/profile/small_profile_component.dart';
import 'package:new_bie/features/profile/viewmodel/my_profile_view_model.dart';
import 'package:provider/provider.dart';

class FollowerListPage extends StatelessWidget {
  final int initialTabIndex;
  const FollowerListPage({super.key, required this.initialTabIndex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${context.read<MyProfileViewModel>().user?.nick_name}'),
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
                      if (viewModel.followerUserProfiles[index] == null) {
                        return const SizedBox.shrink();
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
                              ),
                            ),
                            FollowButton(index: index),
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
                      if (viewModel.followingUserProfiles[index] == null) {
                        return const SizedBox.shrink();
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
                              ),
                            ),
                            FollowButton(index: index),
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
  final int index;
  const FollowButton({super.key, required this.index});

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<FollowListViewModel>();
    final profileUserId = viewModel.followerUserProfiles[widget.index]!.id;

    // 초기 팔로우 여부
    isFollowing = viewModel.isFollowing(profileUserId);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FollowListViewModel>();

    final profileUserId = viewModel.followerUserProfiles[widget.index]!.id;
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
          await viewModel.addFollow(myId, profileUserId);
        } else {
          // 언팔로우
          final followEntity = viewModel.followingUsers.firstWhere(
            (f) => f!.following_id == profileUserId,
          )!;
          await viewModel.unFollow(followEntity.id);
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
