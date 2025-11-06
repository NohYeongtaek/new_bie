import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_bie/src/screens/setting/notice/notice_detail_view_model.dart';
import 'package:new_bie/src/ui_set/fonts.dart';

class NoticeDetailPage extends StatelessWidget {
  const NoticeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoticeDetailViewModel>();

    // 날짜형식
    String formatKoreanDate(String? iso) {
      if (iso == null || iso.isEmpty) return '';
      try {
        final dt = DateTime.parse(iso).toLocal();
        return '${dt.year}년 ${dt.month}월 ${dt.day}일';
      } catch (_) {
        return iso;
      }
    }


    Widget buildBody() {
      if (vm.loading) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 200),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 200),
          ],
        );
      }

      if (vm.error != null) {
        return ListView( // ← const 제거
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            Center(child: Text('오류: ${vm.error}')),
            const SizedBox(height: 120),
          ],
        );
      }

      if (vm.notice == null) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: Text('공지사항이 없습니다.')),
            SizedBox(height: 120),
          ],
        );
      }

      // 공지 데이터 있을 때
      final n = vm.notice!;
      final List<Widget> sections = [
        // 제목
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(n.title ?? '공지사항', style: titleFontStyle),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            formatKoreanDate(n.published_at ?? n.created_at),
            style: dateFontStyle,
          ),
        ),
        // 내용
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Text(n.content ?? '', style: const TextStyle(color: Colors.black)),
        ),
      ];

      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: sections.length,
        separatorBuilder: (_, index) {
          if (index == 0) return const SizedBox(height: 0); // or SizedBox(height: 8)
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: Color(0xFFE5E5E5),
              height: 0.5,
              thickness: 0.5,
            ),
          );
        },
        itemBuilder: (_, i) => sections[i],
      );
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
          onRefresh: vm.load,
          child: buildBody(),
        ),
      ),
    );
  }
}
