import 'package:flutter/material.dart';
import 'package:new_bie/core/utils/ui_set/fonts.dart';
import 'package:new_bie/features/profile/viewmodel/notice_detail_view_model.dart';
import 'package:provider/provider.dart';

class NoticeDetailPage extends StatelessWidget {
  final int noticeId;
  const NoticeDetailPage({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoticeDetailViewModel(context, noticeId: noticeId),
      child: Consumer<NoticeDetailViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('공지사항', style: titleFontStyle),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: false,
              elevation: 0,
            ),

            body: ListView.separated(
              itemCount: 1,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFE5E5E5),
                height: 0.5,
                thickness: 0.5,
              ),

              itemBuilder: (context, index) {
                final noticedetail = viewModel.notice;

                if (noticedetail == null) {
                  return const Center(child: Text('공지사항을 불러올 수 없습니다.'));
                }

                return ListTile(
                  title: Text(
                    noticedetail.title ?? '제목 없음', // 공지제목
                    style: titleFontStyle,
                  ),
                  subtitle: Text(
                    noticedetail.title ?? '', //공지내용
                    style: contentFontStyle,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
