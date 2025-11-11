import 'package:flutter/material.dart';
import 'package:new_bie/core/utils/ui_set/fonts.dart';

class PopupAsk extends StatelessWidget {
  final String content;
  final String noText;
  final String yesText;

  const PopupAsk({
    //기본값
    super.key,
    this.content = '계속하시겠습니까?',
    this.noText = '취소',
    this.yesText = '확인',
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
            // // 본문 텍스트
            Text(content, textAlign: TextAlign.center, style: contentFontStyle),

            const SizedBox(height: 20), // 내용, 버튼 사이 간격

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 취소버튼
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // 팝업 닫기
                    },
                    child: Text(noText),
                  ),
                ),
                const SizedBox(width: 12),
                // // 확인버튼
                Expanded(
                  child: FilledButton(
                    onPressed: () {}, // 다음으로 넘어가기?
                    child: Text(yesText),
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
