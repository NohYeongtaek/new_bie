import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase users 테이블용 User 모델
class User {
  final String id;
  final String nickName;
  final String? profileImage;
  final String? introduction;

  User({
    required this.id,
    required this.nickName,
    this.profileImage,
    this.introduction,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      nickName: map['nick_name'] as String,
      profileImage: map['profile_image'] as String?,
      introduction: map['introduction'] as String?,
    );
  }
}

class UserProfileViewModel extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  // 특정 유저 프로필 불러오기
  Future<void> loadUserProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single(); // execute 제거

      _user = User.fromMap(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('유저 정보 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
