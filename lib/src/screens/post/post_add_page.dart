import 'package:flutter/material.dart';

class PostAddPage extends StatelessWidget {
  const PostAddPage({super.key});

  void _submitPost(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('게시물이 등록되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final hashtagController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 작성'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => _submitPost(context),
            child: const Text(
              '등록',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: '제목을 입력하세요',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                hintText: '내용을 입력하세요',
                border: UnderlineInputBorder(),
              ),
              maxLines: 6,
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('사진 추가 클릭됨')),
                );
              },
              child: Row(
                children: const [
                  Icon(Icons.image, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    '사진 추가',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: hashtagController,
                    decoration: const InputDecoration(
                      hintText: '해시태그 입력',
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '해시태그 "${hashtagController.text}" 추가됨')),
                    );
                    hashtagController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  child: const Text('추가'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

