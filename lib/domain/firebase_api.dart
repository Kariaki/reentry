import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      await firebaseMessaging.requestPermission();
    } catch (e) {}
  }


  static Future<String?> getToken() async {
    try {
      final result = await FirebaseMessaging.instance.getToken();
      return result;
    } catch (e) {
      return '';
    }
  }
}
