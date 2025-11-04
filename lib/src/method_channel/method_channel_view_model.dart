import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MethodChannelViewModel extends ChangeNotifier {
  String? imageUri = null;

  static const MethodChannel imagePlatform = MethodChannel(
    'com.myApp.app/image',
  );

  Future<void> getImage() async {
    //매개변수로 싱글이냐 멀티냐 선택할 수 있게 보낼 수 있다.
    try {
      final String? result = await imagePlatform.invokeMethod<String>(
        "getImageUri",
      );
      imageUri = "${result}";
    } on PlatformException catch (e) {
      imageUri = "get Image 에러 : ${e.message}";
    }
    notifyListeners();
  }
}
