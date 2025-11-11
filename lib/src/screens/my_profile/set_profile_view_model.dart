// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class SetProfileViewModel extends ChangeNotifier {
//   final SupabaseClient supabase = Supabase.instance.client;
//
//   File? _imageFile;
//   String _nickName = '';
//   String _introduction = '';
//   bool _isLoading = false;
//
//   File? get imageFile => _imageFile;
//   String get nickName => _nickName;
//   String get introduction => _introduction;
//   bool get isLoading => _isLoading;
//
//   void setNickName(String value) {
//     _nickName = value;
//     notifyListeners();
//   }
//
//   void setIntroduction(String value) {
//     _introduction = value;
//     notifyListeners();
//   }
//

//
//   Future<void> saveProfile(BuildContext context) async {
//     if (_nickName.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('닉네임을 입력해주세요.')),
//       );
//       return;
//     }
//
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final userId = supabase.auth.currentUser?.id;
//       if (userId == null) throw Exception('로그인 정보가 없습니다.');
//
//       String? profileImageUrl;
//
//
// }
