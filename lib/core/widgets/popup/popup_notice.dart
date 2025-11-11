import 'package:flutter/material.dart';
import 'package:new_bie/core/utils/ui_set/fonts.dart';

class PopupAsk extends StatelessWidget {
  final String title;
  final String content;
  final String confirmedText;
  final String nomoreshowText;

  const PopupAsk({
    //기본값
    super.key,
    this.title = '공지사항',
    this.content = '공지사항 게시 예정입니다.',
    this.confirmedText = '확인',
    this.nomoreshowText = '오늘 다시 보지 않기',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 팝업 모서리
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ), // 외부 여백
      child: Padding(
        padding: const EdgeInsets.all(10), // 내부 여백
        child: Column(
          mainAxisSize: MainAxisSize.min, // 높이 조절
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //공지사항, X버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: titleFontStyle),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  tooltip: 'X',
                ),
              ],
            ),

            const SizedBox(height: 20), // 사이 간격
            //본문내용
            Text(content, textAlign: TextAlign.center, style: contentFontStyle),

            const SizedBox(height: 20), // 사이 간격
            //버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 확인버튼
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // 팝업 닫기
                    },
                    child: Text(confirmedText),
                  ),
                ),
                const SizedBox(width: 12),
                // 오늘 다시보지않기
                Expanded(
                  child: FilledButton(
                    onPressed: () {}, //오늘 다시 보지 않기
                    child: Text(nomoreshowText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
