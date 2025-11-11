import 'package:flutter/material.dart';
import 'package:new_bie/src/entity/follow_entity.dart';

// 팔로우리스트
class FollowListPage extends StatefulWidget {
  final List<FollowEntity> followers;
  final List<FollowEntity> followings;

  const FollowListPage({
    super.key,
    required this.followers,
    required this.followings,
  });

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  bool isFollowerTab = true;

  @override
  Widget build(BuildContext context) {
    final list = isFollowerTab ? widget.followers : widget.followings;
    final hasData = list.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('팔로우', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 탭 버튼
          Row(
            children: [
              _buildTabButton('팔로워', isFollowerTab, () {
                setState(() => isFollowerTab = true);
              }),
              _buildTabButton('팔로잉', !isFollowerTab, () {
                setState(() => isFollowerTab = false);
              }),
            ],
          ),
          const Divider(height: 1),
          // 리스트
          Expanded(
            child: hasData
                ? ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return _FollowListItem(item: item);
                    },
                  )
                : Center(
                    child: Text(
                      isFollowerTab ? '아직 팔로워가 없습니다 🫢' : '아직 팔로잉한 유저가 없습니다 🙈',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool selected, VoidCallback onTap) {
    return Expanded(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: selected ? Colors.white : Colors.grey[100],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// 팔로우리스트
class _FollowListItem extends StatefulWidget {
  final FollowEntity item;

  const _FollowListItem({required this.item});

  @override
  State<_FollowListItem> createState() => _FollowListItemState();
}

class _FollowListItemState extends State<_FollowListItem> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, backgroundColor: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.item.follower_user_id,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                isFollowing = !isFollowing;
              });
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: isFollowing ? Colors.grey[200] : Colors.blue,
              foregroundColor: isFollowing ? Colors.black45 : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(isFollowing ? '팔로잉' : '팔로우'),
          ),
        ],
      ),
    );
  }
}
