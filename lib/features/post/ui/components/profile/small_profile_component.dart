import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';

// 게시물, 게시물 피드용 프로필 컴포넌트임
class SmallProfileComponent extends StatelessWidget {
  final String? imageUrl;
  final String nickName;
  final String introduce;
  final String? userId;
  const SmallProfileComponent({
    super.key,
    this.imageUrl,
    this.userId,
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
          userId == null
              ? SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: imageUrl == null
                        ? Image.asset(
                            'assets/images/user.png',
                            fit: BoxFit.cover,
                          )
                        : Image.network(imageUrl!, fit: BoxFit.cover),
                  ),
                )
              : InkWell(
                  onTap: () {
                    if (userId ==
                        SupabaseManager.shared.supabase.auth.currentUser?.id) {
                      context.push('/my_profile');
                    } else {
                      context.push("/user_profile/${userId}");
                    }
                  },
                  child: SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: imageUrl == null
                          ? Image.asset(
                              'assets/images/user.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(imageUrl!, fit: BoxFit.cover),
                    ),
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
