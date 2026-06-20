import '../services/firebase_service.dart';

Future<String?> sendPhoneOtpJs(String phone) async {
  String? vid;
  String? err;
  await FirebaseService.auth.verifyPhoneNumber(
    phoneNumber: phone,
    verificationCompleted: (_) {},
    verificationFailed: (e) { err = e.message ?? 'فشل'; },
    codeSent: (v, _) { vid = v; },
    codeAutoRetrievalTimeout: (_) {},
    timeout: const Duration(seconds: 60),
  );
  await Future.delayed(const Duration(seconds: 2));
  return err ?? vid;
}

Future<String?> verifyOtpJs(String code) async => null;