import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/notice_entity.dart';

class NoticesRepository {
  //전체공지 목록 조회
  Future<List<NoticeEntity>> fetchNotices() async {
    return await SupabaseManager.shared.fetchNotices();
  }

  //상세 조회
  Future<NoticeEntity?> getById(int id) async {
    return await SupabaseManager.shared.getNoticeById(id);
  }
}
