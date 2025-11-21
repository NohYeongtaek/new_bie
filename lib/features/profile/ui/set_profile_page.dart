import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_bie/core/utils/ui_set/colors.dart';
import 'package:new_bie/features/auth/viewmodel/auth_view_model.dart';
import 'package:new_bie/features/profile/viewmodel/set_profile_view_model.dart';
import 'package:provider/provider.dart';

class SetProfilePage extends StatelessWidget {
  const SetProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SetProfileViewModel(),
      child: Consumer<SetProfileViewModel>(
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
                      '환영합니다! 프로필을 설정해주세요😊',
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
                          backgroundImage: viewModel.imageFile != null
                              ? FileImage(viewModel.imageFile!)
                              : null,
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
                      onChanged: viewModel.setNickName,
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
                      onChanged: viewModel.setIntroduction,
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
                          backgroundColor: orangeColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          // 1. 저장 로직 실행 및 성공 여부 확인
                          final bool isSuccess = await viewModel.saveProfile(
                            context,
                          );

                          if (isSuccess) {
                            // 2. AuthViewModel 가져오기
                            final authVM = context.read<AuthViewModel>();

                            // 3.  최신 사용자 정보(닉네임이 채워진)를 Supabase에서 가져와 AuthVM 갱신
                            await authVM.fetchUser();

                            // 4. 홈 화면으로 이동 (이제 갱신된 AuthVM 정보 덕분에 리디렉트되지 않음)
                            context.go('/home');
                          }
                        },
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
                                '시작하기',
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
