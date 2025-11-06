import 'package:new_bie/src/entity/notice_entity.dart';
import 'package:new_bie/src/managers/supabase_manager.dart';

class NoticesRepository {
  Future<List<NoticeEntity>> fetchNotices() async {
    return await SupabaseManager.shared.fetchNotices();
  }
}
