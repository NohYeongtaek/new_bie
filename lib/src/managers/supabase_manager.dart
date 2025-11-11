import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_bie/src/entity/comments_entity.dart';
import 'package:new_bie/src/entity/likes_entity.dart';
import 'package:new_bie/src/entity/notice_entity.dart';
import 'package:new_bie/src/entity/post_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entity/user_entity.dart';

class SupabaseManager {
  // 이유 - 밖에서 shared를 null등 건드리지 못하게
  // 오 일단 생성이 되었다.
  static final SupabaseManager _shared = SupabaseManager();

  static SupabaseManager get shared => _shared;

  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  // 생성자
  SupabaseManager() {
    debugPrint("SupabaseManager init");
  }

  Future<void> googleSignIn() async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '970264997757-ageb9icp3uccibddetg0q1q1coeiiklm.apps.googleusercontent.com';

    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '970264997757-ouss2eeke35sdtuab620hdccic5scohs.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn signIn = GoogleSignIn.instance;

    // At the start of your app, initialize the GoogleSignIn instance
    unawaited(
      signIn.initialize(clientId: iosClientId, serverClientId: webClientId),
    );

    // Perform the sign in
    final googleAccount = await signIn.authenticate();
    final googleAuthorization = await googleAccount.authorizationClient
        .authorizationForScopes(['email', 'profile']);
    final googleAuthentication = googleAccount.authentication;
    final idToken = googleAuthentication.idToken;
    final accessToken = googleAuthorization?.accessToken;

    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<List<PostEntity>> fetchPosts() async {
    // Map<String, dynamic> <- 이거 하나가 제이슨 이다
    final List<Map<String, dynamic>> data = await supabase
        .from('posts')
        .select();
    // 콜렉션 형태변환
    // T Function(Map<String, dynamic>)
    final List<PostEntity> results = data.map((Map<String, dynamic> json) {
      return PostEntity.fromJson(json);
    }).toList();

    // 다양한 함수의 축약형태
    final List<PostEntity> results2 = data.map((json) {
      return PostEntity.fromJson(json);
    }).toList();

    // 다양한 함수의 축약형태
    final List<PostEntity> results3 = data
        .map((json) => PostEntity.fromJson(json))
        .toList();

    // 다양한 함수의 축약형태
    final List<PostEntity> results4 = data.map(PostEntity.fromJson).toList();

    return results;
  }

  // 공지 목록 조회
  Future<List<NoticeEntity>> fetchNotices() async {
    final List<Map<String, dynamic>> data = await supabase
        .from('notices')
        .select()
        .order('created_at', ascending: false); // 내림차순 정렬

    final List<NoticeEntity> results = data
        .map((json) => NoticeEntity.fromJson(json))
        .toList();

    return results;
  }

  // 공지 상세 조회
  Future<NoticeEntity?> getNoticeById(int id) async {
    final Map<String, dynamic>? row = await supabase
        .from('notices')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (row == null) return null;

    return NoticeEntity.fromJson(row);
  }

  Future<UserEntity> fetchAuthorProfile(String userId) async {
    final List<Map<String, dynamic>> data = await supabase
        .from('users')
        .select()
        .eq('id', userId);

    final List<UserEntity> results2 = data.map((json) {
      return UserEntity.fromJson(json);
    }).toList();

    return results2[0];
  }

  Future<LikeEntity?> fetchLikeItem(int postId, String userId) async {
    final List<Map<String, dynamic>> data = await supabase
        .from('likes')
        .select()
        .eq('user_id', userId)
        .eq('post_id', postId);

    if (data.length == 0) return null;
    final List<LikeEntity> results = data.map((json) {
      return LikeEntity.fromJson(json);
    }).toList();
    return results.first;
  }

  Future<void> insertLike(int postId, String userId) async {
    await supabase.from('likes').insert({'post_id': postId, 'user_id': userId});
  }

  Future<void> cancelLike(int id) async {
    await supabase.from('likes').delete().eq('id', id);
  }

  Future<List<CommentEntity>> fetchComments(int postId) async {
    final List<Map<String, dynamic>> data = await supabase
        .from('comments')
        .select()
        .eq('post_id', postId);

    final List<CommentEntity> results2 = data.map((json) {
      return CommentEntity.fromJson(json);
    }).toList();

    return results2;
  }

  Future<List<int>> fetchCommentIds(int postId) async {
    final List<Map<String, dynamic>> data = await supabase
        .from('comments')
        .select('id')
        .eq('post_id', postId);
    if (data.length == 0) return [];
    final List<int> results2 = data.map((json) {
      return json['id'] as int;
    }).toList();

    return results2;
  }

  Future<void> insertComment(int postId, String userId, String content) async {
    await supabase.from('comments').insert({
      'post_id': postId,
      'author_id': userId,
      'content': content,
    });
  }

  Future<void> deleteComment(int id) async {
    await supabase.from('comments').delete().eq('id', id);
  }

  Future<void> editComment(int commentId, String content) async {
    await supabase
        .from('comments')
        .update({'content': content})
        .eq('id', commentId);
  }

  Future<UserEntity?> fetchUser(String id) async {
    final List<Map<String, dynamic>> data = await supabase
        .from('users')
        .select()
        .eq('id', id);

    if (data.length == 0) return null;
    final List<UserEntity> results = data.map((json) {
      return UserEntity.fromJson(json);
    }).toList();
    return results.first;
  }
}
