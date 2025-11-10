import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_bie/src/managers/supabase_manager.dart';
import 'package:new_bie/src/screens/auth/login/login_view_model.dart';
import 'package:new_bie/src/ui_set/fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _userId;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: SafeArea(
        child: Consumer<LoginViewModel>(
          builder: (context, viewmodel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("/:new_bie", style: titleFontStyle),
                Text("프로그래머를 위한 커뮤니티", style: contentFontStyle),
                SizedBox(height: 150),
                Text(_userId ?? '로그인 안됨'),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
                        await SupabaseManager.shared.googleSignIn();
                      } else {
                        await SupabaseManager.shared.supabase.auth
                            .signInWithOAuth(OAuthProvider.google);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            width: 25,
                            height: 25,
                          ),
                          Text("구글로 시작하기", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
