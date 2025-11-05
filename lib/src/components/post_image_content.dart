import 'package:flutter/material.dart';
import '../ui_set/fonts.dart';

class PostImageContent extends StatelessWidget {
  final String? imageUrl; //이미지 null

  const PostImageContent({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),//좌우상하 내부 간격
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //이미지 있으면 표시
            if (imageUrl != null && imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.contain //비율조정 맞추기
                ),
              ),
          ],
        ),
      ),
    );
  }
}
