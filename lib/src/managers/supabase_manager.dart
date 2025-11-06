import 'package:flutter/material.dart';
import 'package:new_bie/src/entity/post_entity.dart';
import 'package:new_bie/src/entity/notice_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

    final List<NoticeEntity> results =
    data.map((json) => NoticeEntity.fromJson(json)).toList();

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
}
