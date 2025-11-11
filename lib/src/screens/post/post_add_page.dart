import 'dart:io';

import 'package:flutter/material.dart';
import 'package:new_bie/src/screens/post/post_add_view_model.dart';
import 'package:provider/provider.dart';

class PostAddPage extends StatelessWidget {
  const PostAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostAddViewModel(context),
      child: _PostAddPage(),
    );
  }
}

class _PostAddPage extends StatelessWidget {
  const _PostAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    void _submitPost(BuildContext context) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('게시물이 등록되었습니다.')));
    }

    return Consumer<PostAddViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('게시글 작성'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  viewModel.uploadSelectedImages();
                  _submitPost(context);
                },
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
                  controller: viewModel.titleController,
                  decoration: const InputDecoration(
                    hintText: '제목을 입력하세요',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: viewModel.contentController,
                  decoration: const InputDecoration(
                    hintText: '내용을 입력하세요',
                    border: UnderlineInputBorder(),
                  ),
                  maxLines: 6,
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    viewModel.getImages();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('사진 추가 클릭됨')));
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
                if (viewModel.mediaFileList.length != 0)
                  SizedBox(
                    height: 166,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: viewModel.mediaFileList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Image.file(
                              File(viewModel.mediaFileList[index].path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: viewModel.hashtagController,
                        decoration: const InputDecoration(
                          hintText: '해시태그 입력',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '해시태그 "${viewModel.hashtagController.text}" 추가됨',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      child: const Text('추가'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
