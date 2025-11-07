import 'package:flutter/material.dart';
import 'package:new_bie/src/screens/auth/login/login_view_model.dart';
import 'package:new_bie/src/ui_set/fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      viewmodel.nativeGoogleSignIn();
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
