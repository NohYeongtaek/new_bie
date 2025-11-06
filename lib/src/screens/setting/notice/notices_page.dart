import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_bie/src/screens/setting/notice/notice_detail_page.dart';
import 'package:new_bie/src/screens/setting/notice/notice_detail_view_model.dart';
import 'package:new_bie/src/screens/setting/notice/notices_view_model.dart';
import 'package:new_bie/src/screens/setting/notice/notices_repository.dart';
import 'package:new_bie/src/entity/notice_entity.dart';
import 'package:new_bie/src/ui_set/fonts.dart';

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoticesViewModel>();

    // 날짜
    String formatKoreanDate(String? iso) {
      if (iso == null || iso.isEmpty) return '';
      try {
        final dt = DateTime.parse(iso).toLocal();
        return '${dt.year}년 ${dt.month}월 ${dt.day}일';
      } catch (_) {
        return iso;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: vm.fetchNotices,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: vm.notices.length,
            separatorBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16), // 좌우 여백
              child: Divider(
                color: Color(0xFFE5E5E5), // 회색선
                height: 0.5,
                thickness: 0.5,
              ),
            ),
            itemBuilder: (context, index) {
              final NoticeEntity n = vm.notices[index];

              return ListTile(
                // 제목
                title: Text(n.title ?? '공지사항', style: titleFontStyle,
                ),

                // 날짜
                subtitle: Text(formatKoreanDate(n.published_at ?? n.created_at),
                  style: dateFontStyle,
                ),
                // 우측 꺾쇠
                trailing: const Icon(Icons.chevron_right),
                // 탭 시 상세 페이지 이동
                onTap: () {
                  final id = n.id ?? 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (ctx) => NoticeDetailViewModel(
                          ctx.read<NoticesRepository>(),
                          noticeId: id,
                        )..load(),
                        child: const NoticeDetailPage(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
