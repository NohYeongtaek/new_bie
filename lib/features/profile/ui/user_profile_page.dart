import 'package:flutter/material.dart';
import 'package:new_bie/features/post/ui/components/profile/small_profile_component.dart';
import 'package:new_bie/features/profile/viewmodel/user_profile_view_model.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  final int userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProfileViewModel()..loadUserProfile(userId),
      child: Consumer<UserProfileViewModel>(
        builder: (context, viewModel, child) {
          final user = viewModel.user;

          return Scaffold(
            backgroundColor: const Color(0xFFF6F6F6),
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
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              SmallProfileComponent(
                                imageUrl: user?.profileImage,
                                nickName: user?.nickName ?? '닉네임 없음',
                                introduce: user?.introduction ?? '자기소개가 없습니다.',
                              ),

                              const SizedBox(height: 20),

                              // 팔로우 버튼 (추후 구현)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
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
                          color: Colors.white,
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
                                child: _buildPostGridView([]),
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

  static Widget _buildPostGridView(List<Map<String, dynamic>> posts) {
    if (posts.isEmpty) return const Center(child: Text('아직 게시물이 없습니다.'));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: posts.map((post) {
          if (post['type'] == 'image') {
            return _buildPostImage(post['url']);
          } else {
            return _buildPostTextCard(post['content']);
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
        color: Colors.grey.shade200,
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
