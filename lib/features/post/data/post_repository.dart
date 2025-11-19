import 'package:new_bie/core/models/managers/network_api_manager.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/category_type_entity.dart';
import 'package:new_bie/features/post/data/entity/comment_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/likes_entity.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/search_result_entity.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';

class PostRepository {
  // 반환 형태가 무엇이 되어야 할까요?
  // List<Task>
  Future<List<PostWithProfileEntity>> fetchPosts(
    String orderBy, {
    int currentIndex = 1,
    required String category,
  }) async {
    return await NetworkApiManager.shared.fetchPosts(
      orderBy,
      currentIndex: currentIndex,
      category: category,
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

  Future<void> cancelLike(int postId, String userId) async {
    await SupabaseManager.shared.cancelLike(postId, userId);
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
    List<int> categories,
  ) async {
    await NetworkApiManager.shared.insertPost(
      userId,
      title,
      content,
      images,
      categories,
    );
  }

  Future<List<String>> getCategoryList() async {
    return await SupabaseManager.shared.getCategoryList();
  }

  Future<List<CategoryTypeEntity>> getCategoryTypeList() async {
    return await SupabaseManager.shared.getCategoryTypeList();
  }

  Future<void> updatePost(
    int postId,
    String title,
    String content,
    List<String> images,
    List<int> categories,
  ) async {
    await NetworkApiManager.shared.updatePost(
      postId,
      title,
      content,
      images,
      categories,
    );
  }

  Future<SearchResultEntity> searchAll(
    String keyword, {
    String type = "all",
    int currentIndex = 1,
    int perPage = 5,
  }) async {
    return NetworkApiManager.shared.searchAll(
      keyword,
      type: type,
      currentIndex: currentIndex,
      perPage: perPage,
    );
  }

  Future<void> deletePost(int postId) async {
    await NetworkApiManager.shared.deletePost(postId);
  }

  Future<List<CommentWithProfileEntity>> fetchComments(int postId) async {
    return await NetworkApiManager.shared.fetchComments(postId);
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
