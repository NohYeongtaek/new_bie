import 'package:new_bie/src/entity/notice_entity.dart';
import 'package:new_bie/src/managers/supabase_manager.dart';

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
