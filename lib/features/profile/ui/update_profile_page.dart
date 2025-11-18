import 'package:flutter/material.dart';
import 'package:new_bie/features/profile/viewmodel/update_profile_viewmodel.dart';
import 'package:provider/provider.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UpdateProfileViewmodel(),
      child: Consumer<UpdateProfileViewmodel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('프로필 설정'), centerTitle: false),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // 안내 문구
                    const Text(
                      '프로필을 설정해주세요😊',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 프로필 이미지
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: viewModel.profileImage,
                          child: viewModel.imageFile == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: InkWell(
                            onTap: viewModel.pickImage,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('선택사항', style: TextStyle(color: Colors.grey)),

                    const SizedBox(height: 24),

                    // 닉네임 입력
                    TextField(
                      controller: viewModel.nickNameController,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        labelText: '닉네임 *',
                        hintText: '닉네임을 입력하세요',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 자기소개 입력
                    TextField(
                      controller: viewModel.introductionController,
                      maxLength: 150,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: '자기소개',
                        hintText: '자기소개를 입력하세요',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 시작하기 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: viewModel.isLoading
                            ? null
                            : () => viewModel.saveProfile(context),
                        child: viewModel.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                '저장 하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
