import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';

import '../../../core/utils/ui_set/colors.dart';

class DeletedUserPage extends StatelessWidget {
  const DeletedUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.delete_forever, color: Colors.red, size: 80),
              const SizedBox(height: 20),
              const Text(
                "삭제된 계정입니다",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "관리자에게 문의해주세요.",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  SizedBox(
                    width: 150,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(orangeColor),
                      ),
                      onPressed: () async {
                        // 로그아웃 확실히 하고 이동
                        await SupabaseManager.shared.supabase.auth.signOut();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                      child: const Text("로그인 화면으로 이동"),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(orangeColor),
                      ),
                      onPressed: () async {
                        if (context.mounted) {
                          context.go('/home');
                        }
                        await SupabaseManager.shared.supabase.auth.signOut();
                      },
                      child: const Text("홈 화면으로 이동"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
