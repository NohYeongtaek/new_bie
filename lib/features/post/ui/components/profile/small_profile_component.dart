import 'package:flutter/material.dart';

// 게시물, 게시물 피드용 프로필 컴포넌트임
class SmallProfileComponent extends StatelessWidget {
  final String? imageUrl;
  final String nickName;
  final String introduce;
  const SmallProfileComponent({
    super.key,
    this.imageUrl,
    required this.nickName,
    required this.introduce,
  });

  final double imageSize = 60;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: imageUrl == null
                  ? Image.asset('assets/images/user.png', fit: BoxFit.cover)
                  : Image.network(imageUrl!, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(nickName),
                Text(
                  introduce,
                  style: TextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
