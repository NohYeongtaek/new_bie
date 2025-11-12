import 'package:new_bie/core/models/managers/network_api_manager.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/comment_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/likes_entity.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';

class PostRepository {
  // 반환 형태가 무엇이 되어야 할까요?
  // List<Task>
  Future<List<PostWithProfileEntity>> fetchPosts(
    String orderBy, {
    int currentIndex = 1,
  }) async {
    return await NetworkApiManager.shared.fetchPosts(
      orderBy,
      currentIndex: currentIndex,
    );
  }

  Future<PostWithProfileEntity> fetchPostItem(int id) async {
    return await NetworkApiManager.shared.fetchPostItem(id);
  }

  Future<UserEntity> fetchAuthorProfile(String userId) async {
    return await SupabaseManager.shared.fetchAuthorProfile(userId);
  }

  Future<int> getPostLikeCount(int postId) async {
    return await NetworkApiManager.shared.getPostLikeCount(postId);
  }

  Future<LikeEntity?> fetchLikeItem(int postId, String userId) async {
    return await SupabaseManager.shared.fetchLikeItem(postId, userId);
  }

  Future<void> insertLike(int postId, String userId) async {
    await SupabaseManager.shared.insertLike(postId, userId);
  }

  Future<void> cancelLike(int id) async {
    await SupabaseManager.shared.cancelLike(id);
  }

  Future<List<int>> fetchCommentIds(int postId) async {
    return await SupabaseManager.shared.fetchCommentIds(postId);
  }

  Future<CommentWithProfileEntity> fetchCommentItem(int id) async {
    return await NetworkApiManager.shared.fetchCommentItem(id);
  }

  Future<void> insertComment(int postId, String userId, String content) async {
    await SupabaseManager.shared.insertComment(postId, userId, content);
  }

  Future<void> deleteComment(int id) async {
    await SupabaseManager.shared.deleteComment(id);
  }

  Future<void> editComment(int commentId, String content) async {
    await SupabaseManager.shared.editComment(commentId, content);
  }

  Future<void> insertPost(
    String userId,
    String title,
    String content,
    List<String> images,
  ) async {
    await NetworkApiManager.shared.insertPost(userId, title, content, images);
  }

  // Future<void> addMemo(String content) async {
  //   return await NetworkApiManager.shared.addMemo(content);
  // }
  //
  // //디테일 데이터 불러오기 (API)
  // Future<Memo> fetchMemoDetail(int detailId) async {
  //   return await NetworkApiManager.shared.fetchMemoDetail(id: detailId);
  // }
  //
  // //삭제(슈퍼베이스)
  // Future<void> deleteMemo(int detailId) async {
  //   return await SupabaseManager.shared.deleteMemo(detailId: detailId);
  // }
  //
  // //수정(슈퍼베이스)
  // Future<void> updateMemo(int detailId, String updatedContent) async {
  //   return await SupabaseManager.shared.updateMemo(
  //     detailId: detailId,
  //     updatedContent: updatedContent,
  //   );
  // }
}
