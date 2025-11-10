import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'comments_listview.dart';

class CommentButton extends StatelessWidget {
  final int comments_count;
  final int postId;
  const CommentButton({
    super.key,
    required this.comments_count,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showBarModalBottomSheet(
          context: context,
          // isScrollControlled: true,
          // useSafeArea: true,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          // ),
          expand: true,
          clipBehavior: Clip.antiAlias,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(title: Text("댓글"), centerTitle: true),
              body: CommentsListview(postId: postId),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 10,
          children: [
            Icon(Icons.comment_outlined, color: Colors.white),
            Text("${comments_count}"),
          ],
        ),
      ),
    );
  }
}

// SizedBox(
// height: 200,
// child: Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// mainAxisSize: MainAxisSize.min,
// children: <Widget>[
// const Text('Modal BottomSheet'),
// ElevatedButton(
// child: const Text('Close BottomSheet'),
// onPressed: () => Navigator.pop(context),
// ),
// ],
// ),
// ),
// )
