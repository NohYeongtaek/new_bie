import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/features/profile/viewmodel/notices_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/extension/time_extension.dart';
import '../../../core/utils/ui_set/fonts.dart' show titleFontStyle;

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoticesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        elevation: 0,
      ),

      body: ListView.separated(
        itemCount: vm.notices.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        separatorBuilder: (context, index) =>
            const Divider(color: Colors.white54, height: 0.5, thickness: 0.5),

        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              vm.notices[index].title ?? '제목 없음', // 제목
              style: titleFontStyle,
            ),
            subtitle: Text(
              timeAgo(vm.notices[index].created_at.toDateTime()),
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // 상세 페이지 이동
              context.push(
                '/my_profile/setting/notice/${vm.notices[index].id}',
              );
            },
          );
        },
      ),
    );
  }
}
