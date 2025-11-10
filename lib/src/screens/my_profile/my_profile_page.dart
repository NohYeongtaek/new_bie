import 'package:flutter/material.dart';
import 'package:new_bie/src/entity/user_entity.dart';
import 'package:new_bie/src/components/small_profile_component.dart';
import 'package:go_router/go_router.dart';

class MyProfilePage extends StatelessWidget {
  final UserEntity user;

  const MyProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          '마이페이지',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필
            Container(
              color: Colors.white,
              padding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: [
                  SmallProfileComponent(
                    imageUrl: user.profile_image,
                    nickName: user.nick_name ?? '닉네임 없음',
                    introduce: user.introduction ?? '자기소개가 없습니다.',
                  ),

                  const SizedBox(height: 20),

                  // 팔로워, 팔로잉부분
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${user.follower_count}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          const Text('팔로워',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(width: 40),
                      Column(
                        children: [
                          Text(
                            '${user.following_count}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          const Text('팔로잉',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 프로필 수정버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // 프로필 수정 페이지 이동
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('프로필 수정'),
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
                    padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
  }

  // 게시물 리스트
  static Widget _buildPostGridView(List<Map<String, dynamic>> posts) {
    if (posts.isEmpty) {
      return const Center(child: Text('아직 게시물이 없습니다.'));
    }

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

