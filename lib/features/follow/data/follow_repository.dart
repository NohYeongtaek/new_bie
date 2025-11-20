import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/follow/data/entity/follow_entity.dart';

class FollowRepository {
  static final FollowRepository _instance = FollowRepository._internal();
  factory FollowRepository() => _instance;
  FollowRepository._internal();

  static FollowRepository get shared => _instance;

  /// 특정 사용자가 팔로우하는 사람들의 목록 조회 (팔로잉)
  Future<List<FollowEntity?>> fetchFollowingUsers(String id) async {
    final data = await SupabaseManager.shared.supabase
        .from('follow')
        .select()
        .eq('follower_id', id);

    return data.map((json) => FollowEntity.fromJson(json)).toList();
  }

  /// 특정 사용자의 팔로워와 팔로잉 관계를 한 번의 쿼리로 조회
  Future<List<FollowEntity?>> fetchAllFollowRelations(String userId) async {
    final data = await SupabaseManager.shared.supabase
        .from('follow')
        .select()
        .or('following_id.eq.$userId,follower_id.eq.$userId');

    return data.map((json) => FollowEntity.fromJson(json)).toList();
  }

  /// 팔로우 관계 추가
  Future<void> addFollow(String followerId, String followingId) async {
    await SupabaseManager.shared.supabase.from('follow').insert({
      'follower_id': followerId,
      'following_id': followingId,
    });
  }

  /// 팔로우 관계 삭제
  Future<void> deleteFollow(int id) async {
    await SupabaseManager.shared.supabase.from('follow').delete().eq('id', id);
  }
}