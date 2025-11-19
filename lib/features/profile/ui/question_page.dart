import 'package:flutter/material.dart';
import 'package:new_bie/features/profile/viewmodel/question_viewmodel.dart';
import 'package:provider/provider.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  void _sendInquiry(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('문의가 전송되었습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('문의하기'),
        actions: [
          TextButton(
            onPressed: () => _sendInquiry(context),
            child: const Text(
              '전송',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Consumer<QuestionViewmodel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const Text(
                  '이메일 *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: '답변 받을 이메일을 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                const Text(
                  '제목 *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: '문의 제목을 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '내용 *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    hintText: '문의 내용을 자세히 입력해주세요',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 6,
                ),
                const SizedBox(height: 20),
                const Text(
                  '문의하신 내용은 영업일 기준 1–2일 내에 답변 드립니다.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
