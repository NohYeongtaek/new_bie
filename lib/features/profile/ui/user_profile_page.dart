import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/follow/viewmodel/follow_list_view_model.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/ui/components/profile/small_profile_component.dart';
import 'package:new_bie/features/profile/viewmodel/user_profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/ui_set/colors.dart';
import '../../follow/data/entity/follow_entity.dart';
import '../../post/data/entity/user_entity.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;
  final String targetUserId;

  const UserProfilePage({
    super.key,
    required this.userId,
    required this.targetUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProfileViewModel(userId, context),
      child: Consumer<UserProfileViewModel>(
        builder: (context, viewModel, child) {
          final user = viewModel.user;

          return Scaffold(
            backgroundColor: blackColor,
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
              centerTitle: false,
              elevation: 0,
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: viewModel.loadUserProfile,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            color: blackColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            child: Column(
                              children: [
                                SmallProfileComponent(
                                  imageUrl: user?.profile_image,
                                  nickName: user?.nick_name ?? '닉네임 없음',
                                  introduce:
                                      user?.introduction ?? '자기소개가 없습니다.',
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            context.push(
                                              '/user_profile/${targetUserId}/follower?initialTab=0',
                                            );
                                          },
                                          child: Text(
                                            '${viewModel.user?.follower_count}',
                                            style: const TextStyle(
                                              color: orangeColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        GestureDetector(
                                          onTap: () {
                                            context.push(
                                              '/user_profile/${targetUserId}/follower?initialTab=0',
                                            );
                                          },
                                          child: Text(
                                            '팔로워',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 40),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            context.push(
                                              '/user_profile/${targetUserId}/follower?initialTab=1',
                                            );
                                          },
                                          child: Text(
                                            '${viewModel.user?.following_count}',
                                            style: const TextStyle(
                                              color: orangeColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        GestureDetector(
                                          onTap: () {
                                            context.push(
                                              '/user_profile/${targetUserId}/follower?initialTab=1',
                                            );
                                          },
                                          child: Text(
                                            '팔로잉',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // 팔로우 버튼 (추후 구현)
                                FollowButton(
                                  userProfile: viewModel.user,
                                  followEntity: viewModel.isFollow,
                                  isInitialFollowing: viewModel.isFollowing,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // 게시물
                          Container(
                            color: blackColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    '게시물',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 400,
                                  child: _buildPostGridView(
                                    viewModel.posts,
                                    viewModel,
                                    context,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  // 게시물 리스트
  static Widget _buildPostGridView(
    List<PostWithProfileEntity> posts,
    UserProfileViewModel viewMode,
    BuildContext context,
  ) {
    if (posts.isEmpty) {
      return const Center(child: Text('아직 게시물이 없습니다.'));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        controller: viewMode.scrollController,
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: posts.map((post) {
          if (post.postImages.length != 0) {
            return InkWell(
              onTap: () {
                context.push('/post/${post.id}');
              },
              child: _buildPostImage(post.postImages[0].image_url),
            );
          } else {
            return InkWell(
              onTap: () {
                context.push('/post/${post.id}');
              },
              child: _buildPostTextCard(post.content ?? ""),
            );
          }
        }).toList(),
      ),
    );
  }

  static Widget _buildPostImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(url, fit: BoxFit.cover),
    );
  }

  static Widget _buildPostTextCard(String text) {
    return Container(
      decoration: BoxDecoration(
        color: greedColor,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

//내가 팔로우 하고 있는지 아닌지 데이터만 땡겨오면 된다

class FollowButton extends StatefulWidget {
  final UserEntity? userProfile; // 해당 유저 프로필
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
          await viewModel.addFollow(myId, widget.userProfile!.id);
        } else {
          // 언팔로우 (followEntity가 null일 수 있으므로 주의)
          final targetFollowEntity =
              widget.followEntity ??
              viewModel.followingUsers.firstWhere(
                (f) => f!.following_id == widget.userProfile?.id,
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
        padding: const EdgeInsets.symmetric(horizontal: 146, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isFollowing ? "팔로잉" : "팔로우",
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
