import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_bie/src/ui_set/fonts.dart';
import 'package:new_bie/src/screens/setting/blocked_user/blocked_user_view_model.dart';
import 'package:new_bie/src/components/small_profile_component.dart';

class BlockedUserPage extends StatelessWidget {
  const BlockedUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BlockedUserViewModel>();

    return Scaffold(
      appBar: AppBar(
          title: Text('차단된 사용자 목록', style: titleFontStyle,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: false,
      elevation: 0,
    ),

      body: ListView.separated(
        itemCount: vm.blockUsers.length, //이 줄 다시보기
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        separatorBuilder: (context, index) => const Divider(
          color: Color(0xFFE5E5E5),
          height: 0.5,
          thickness: 0.5,
        ),

        itemBuilder: (context, index) {
          final user = vm.blockUsers[index];

          return ListTile(
              title: SmallProfileComponent(
                imageUrl: user.profileImage,
                nickName: user.nickname,
                introduce: user.introduce ?? '',

              ),
              trailing: TextButton(
                onPressed: () => vm.unblockUser(user),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    '차단 해제', style: buttonFontStyle),
                ),
              ),
          );
        },
      ),
    );
  }
}

