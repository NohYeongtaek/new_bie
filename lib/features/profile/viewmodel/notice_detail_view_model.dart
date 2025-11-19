import 'package:flutter/material.dart';
import 'package:new_bie/features/post/data/entity/notice_entity.dart';
import 'package:new_bie/features/profile/data/notices_repository.dart';
import 'package:provider/provider.dart';

class NoticeDetailViewModel extends ChangeNotifier {
  final NoticesRepository _repository;
  final int noticeId;

  bool _loading = false;
  NoticeEntity? _notice;
  String? _error;

  bool get loading => _loading;
  NoticeEntity? get notice => _notice;
  String? get error => _error;

  NoticeDetailViewModel(BuildContext context, {required this.noticeId})
    : _repository = context.read<NoticesRepository>() {
    load();
  }

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _notice = await _repository.getById(noticeId);
    } catch (e) {
      _error = e.toString();
      _notice = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
