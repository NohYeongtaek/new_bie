import 'package:new_bie/src/entity/post_entity.dart';
import 'package:new_bie/src/managers/supabase_manager.dart';

class PostRepository {
  // 반환 형태가 무엇이 되어야 할까요?
  // List<Task>
  Future<List<PostEntity>> fetchPosts() async {
    return await SupabaseManager.shared.fetchPosts();
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
