import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_bie/src/screens/setting/notice/notices_view_model.dart';
import 'package:new_bie/src/ui_set/fonts.dart';
import 'package:new_bie/src/extension/time_extension.dart';

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoticesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항', style: titleFontStyle,
        ),
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

        separatorBuilder: (context, index) => const Divider(
          color: Color(0xFFE5E5E5),
          height: 0.5,
          thickness: 0.5,
        ),

        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              vm.notices[index].title ?? '제목 없음', // 제목
              style: titleFontStyle,
            ),
            subtitle: Text(
              vm.notices[index].created_at != null
                  ? timeAgo(vm.notices[index].created_at!.toDateTime())
                  : '',
              style: dateFontStyle,
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // 상세 페이지 이동
              Navigator.pushNamed(
                context,
                '/notice_detail',
                arguments: vm.notices[index],
              );
            },
          );
        },
      ),
    );
  }
}