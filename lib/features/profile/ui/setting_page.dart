import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/auth/viewmodel/auth_view_model.dart';
import 'package:new_bie/features/profile/viewmodel/my_profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/popup/popup_ask.dart';

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
        title: const Text('설정', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: greedColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.chat_bubble_outline, color: Colors.white),
                  title: const Text(
                    '문의하기',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  onTap: () {
                    context.push('/my_profile/setting/question');
                  },
                ),
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(Icons.notifications_none, color: Colors.white),
                  title: const Text(
                    '공지사항',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  onTap: () {
                    context.push('/my_profile/setting/notice');
                  },
                ),
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(Icons.block_outlined, color: Colors.white),
                  title: const Text(
                    '차단한 사용자',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  onTap: () {
                    context.push('/my_profile/setting/blocked_users');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: greedColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    '로그아웃',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return PopupAsk(
                          content: '로그아웃 하시겠습니까?',
                          yesText: '확인',
                          noText: '취소',
                          yesLogic: () async {
                            Navigator.pop(dialogContext);
                            await context.read<AuthViewModel>().logout(
                              onLoggedOut: () {
                                context.go('/home');
                              },
                            );
                          },
                        );
                      },
                    );
                    // context.read<AuthViewModel>().logout(
                    //   onLoggedOut: () {
                    //     context.go('/home');
                    //   },
                    // );
                  },
                ),
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    '탈퇴하기',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return PopupAsk(
                          content: '정말 탈퇴하시겠습니까?',
                          inputContentTextStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          yesText: '확인',
                          noText: '취소',
                          yesLogic: () async {
                            Navigator.pop(dialogContext);
                            await context
                                .read<MyProfileViewModel>()
                                .unRegister();
                            context.go('login');
                          },
                        );
                      },
                    );
                  },
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
                  style: TextStyle(color: orangeColor, fontSize: 14),
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
