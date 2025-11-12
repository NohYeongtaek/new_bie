import 'package:flutter/material.dart';
import 'package:new_bie/features/block_users/viewmodel/blocked_user_view_model.dart';
import 'package:new_bie/features/post/ui/components/profile/small_profile_component.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/ui_set/fonts.dart'
    show titleFontStyle, buttonFontStyle;

class BlockedUserPage extends StatelessWidget {
  const BlockedUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차단된 사용자 목록', style: titleFontStyle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        elevation: 0,
      ),

      body: SafeArea(
        child: Consumer<BlockedUserViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.blockedUserProfiles.length, //이 줄 다시보기
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      if (viewModel.blockedUserProfiles[index] == null) {
                        return const SizedBox.shrink();
                      }
                      return SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: SmallProfileComponent(
                                imageUrl: viewModel
                                    .blockedUserProfiles[index]
                                    ?.profile_image,
                                nickName:
                                    viewModel
                                        .blockedUserProfiles[index]
                                        ?.nick_name ??
                                    '',
                                introduce:
                                    viewModel
                                        .blockedUserProfiles[index]
                                        ?.introduction ??
                                    '',
                              ),
                            ),
                            TextButton(
                              onPressed: () => viewModel.deleteBlockedUser(
                                viewModel.blockUsers[index]?.id ?? 0,
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text('차단 해제', style: buttonFontStyle),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
