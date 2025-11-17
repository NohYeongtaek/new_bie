import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';

import '../../../core/models/event_bus/follow_list_event_bus.dart';
import '../../../main.dart';

class MyProfileViewModel extends ChangeNotifier {
  // int inputCount = 0;

  // final TextEditingController textEditingController = TextEditingController();

  // 뷰모델 생성자, context를 통해 리포지토리를 받아올 수 있음.
  UserEntity? user;
  StreamSubscription? _subscription;

  MyProfileViewModel(BuildContext context) {
    fetchUser();

    _subscription = eventBus.on<FollowListEventBus>().listen((event) {
      switch (event.type) {
        case FollowEventType.unFollow:
          fetchUser();
          break;
        case FollowEventType.addFollow:
          fetchUser();
          break;
      }
    });
  }
  Future<void> fetchUser() async {
    final String? userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    if (userId == null) return;
    user = await SupabaseManager.shared.fetchUser(userId);
    notifyListeners();
  }
  // 입력한 글자 수를 받아오는 함수
  // void handleTextInput(String input) {
  //   inputCount = input.length;
  //   notifyListeners();
  // }

  // Future 함수는 API나 Supabase, 메소드 채널과 사용할 때,
  // 처리를 하는데 시간이 걸리는 작업을 할때 사용됨.
  // 아래 함수 안 에서는 시간이 필요한 작업은 await를 사용 해야함
  // Future<void> function() async {
  //   try {
  //
  //   } catch (e) {
  //
  //   }
  //
  //   // 리빌딩, 리콤포지션 진행
  //   notifyListeners();
  // }
  // Future<void> function1() async {
  //   // 시간 지연 코드
  //   await Future.delayed(const Duration(milliseconds: 1700));
  //   notifyListeners();
  // }
}
