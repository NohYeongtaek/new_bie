import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  late StreamSubscription<AuthState> _subscription;

  AuthViewModel() {
    // Supabase 인증 상태 구독
    _subscription = _subscribeAuthEvent();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // 로그아웃 함수 (빠른 반응 + 백그라운드 처리)
  Future<void> logout({VoidCallback? onLoggedOut}) async {
    _isLoggedIn = false;
    notifyListeners();

    onLoggedOut?.call();

    unawaited(_performLogoutTasks());
  }

  Future<void> _performLogoutTasks() async {
    try {
      final googleSignIn = GoogleSignIn.instance;

      // Google 로그아웃 시도 (에러 무시)
      try {
        await googleSignIn.signOut();
        await googleSignIn.disconnect();
      } catch (e) {
        debugPrint('⚠️ Google logout error: $e');
      }

      // Supabase 세션 로그아웃
      await SupabaseManager.shared.supabase.auth.signOut();
    } catch (e) {
      debugPrint('⚠️ Logout failed: $e');
    }

    debugPrint('✅ Background logout completed');
  }

  //  Supabase 인증 상태 구독
  StreamSubscription<AuthState> _subscribeAuthEvent() {
    return SupabaseManager.shared.supabase.auth.onAuthStateChange.listen((
      data,
    ) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      _isLoggedIn = session != null;
      notifyListeners();

      debugPrint('[AuthVM] event: $event, session: $session');
    });
  }
}
