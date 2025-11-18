import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/features/follow/viewmodel/follow_list_view_model.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/ui/components/profile/small_profile_component.dart';
import 'package:new_bie/features/profile/viewmodel/user_profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/ui_set/colors.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

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
              title: const Text(
                '유저 프로필',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
              elevation: 0,
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
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
                                imageUrl: user?.profileImage,
                                nickName: user?.nick_name ?? '닉네임 없음',
                                introduce: user?.introduction ?? '자기소개가 없습니다.',
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // FollowerListPage에서 fetchAllFollowData를 호출하므로 여기서는 불필요
                                          context.push(
                                            '/user_profile/${userId}/follower?initialTab=0',
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
                                          // FollowerListPage에서 fetchAllFollowData를 호출하므로 여기서는 불필요
                                          context.push(
                                            '/user_profile/${userId}/follower?initialTab=0',
                                          );
                                        },
                                        child: Text(
                                          '팔로워',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 40),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // FollowerListPage에서 fetchAllFollowData를 호출하므로 여기서는 불필요
                                          context.push(
                                            '/user_profile/${userId}/follower?initialTab=1',
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
                                          // FollowerListPage에서 fetchAllFollowData를 호출하므로 여기서는 불필요
                                          context.push(
                                            '/user_profile/${userId}/follower?initialTab=1',
                                          );
                                        },
                                        child: Text(
                                          '팔로잉',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // 팔로우 버튼 (추후 구현)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: orangeColor,
                                    foregroundColor: blackColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    // 팔로우/언팔
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text('팔로우'),
                                  ),
                                ),
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
