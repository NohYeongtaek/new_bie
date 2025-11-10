import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/src/screens/auth/auth_view_model.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('설정'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.chat_bubble_outline),
                  title: const Text('문의하기'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.notifications_none),
                  title: const Text('공지사항'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.block_outlined),
                  title: const Text('차단한 사용자 목록'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.logout),
                  title: const Text('로그아웃'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.read<AuthViewModel>().logout();
                    context.go('/home');
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    '탈퇴하기',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Center(
            child: Column(
              children: const [
                Text(
                  '뉴비 v1.0.0',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  '© 2025 Newbie. All rights reserved.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
