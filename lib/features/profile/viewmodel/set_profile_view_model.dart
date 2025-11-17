import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SetProfileViewModel extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  File? _imageFile;
  String _nickName = '';
  String _introduction = '';
  bool _isLoading = false;

  File? get imageFile => _imageFile;
  String get nickName => _nickName;
  String get introduction => _introduction;
  bool get isLoading => _isLoading;

  void setNickName(String value) {
    _nickName = value;
    notifyListeners();
  }

  void setIntroduction(String value) {
    _introduction = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _imageFile = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    if (_nickName.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('닉네임을 입력해주세요.')));
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('로그인 정보가 없습니다.');

      String? profileImageUrl;

      // 프로필 이미지 업로드
      if (_imageFile != null) {
        final fileName =
            'avatars/$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';
        await supabase.storage
            .from('avatars')
            .upload(
              fileName,
              _imageFile!,
              fileOptions: const FileOptions(
                headers: {
                  "Authorization":
                      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc",
                },
                cacheControl: '3600',
                upsert: false,
              ),
            );

        profileImageUrl = supabase.storage
            .from('avatars')
            .getPublicUrl(fileName);
      }

      // users 테이블에 저장
      await supabase.from('users').upsert({
        'id': userId,
        'nick_name': _nickName,
        'introduction': _introduction,
        if (profileImageUrl != null) 'profile_image': profileImageUrl,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('프로필이 저장되었습니다!👍')));
    } catch (e) {
      debugPrint('프로필 저장 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('프로필 저장에 실패했습니다: $e')));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
