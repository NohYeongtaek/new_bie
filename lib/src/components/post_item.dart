import 'package:flutter/material.dart';
import 'package:new_bie/src/entity/post_entity.dart';
import 'package:new_bie/src/ui_set/colors.dart';
import 'package:new_bie/src/ui_set/fonts.dart';

class PostItem extends StatelessWidget {
  final PostEntity post;
  // final String? title;
  // final String? content;
  // final String created_at;

  const PostItem({
    super.key,
    // this.title,
    // this.content,
    // required this.created_at,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(post.title ?? "제목 없음", style: titleFontStyle),
          Text(post.created_at, style: dateFontStyle),
          Text(
            post.content ?? "내용 없음",
            style: contentFontStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    Text("${post.likes_count}"),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.comment_outlined, color: orangeColor),
                    Text("${post.comments_count}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
