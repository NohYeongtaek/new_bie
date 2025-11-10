import 'package:flutter/material.dart';
import 'package:new_bie/src/entity/notice_entity.dart';
import 'package:new_bie/src/screens/setting/notice/notices_repository.dart';

class NoticesViewModel extends ChangeNotifier {
  final NoticesRepository _repository;

  bool _loading = false;
  String? _error;
  List<NoticeEntity> _notices = [];

  bool get loading => _loading;
  String? get error => _error;
  List<NoticeEntity> get notices => _notices;

  NoticesViewModel(this._repository);

  Future<void> fetchNotices() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _notices = await _repository.fetchNotices();
    } catch (e) {
      _error = e.toString();
      _notices = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
