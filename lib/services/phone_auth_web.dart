import 'package:web/web.dart' as web;

Future<String?> sendPhoneOtpJs(String phone) async {
  final phoneAuth = web.globalThis['_phoneAuth'];
  if (phoneAuth == null) return 'خطأ: Firebase غير محمّل';
  try {
    final dynamic promise = phoneAuth.call('sendOtp', phone);
    final dynamic result = await promise;
    return result as String?;
  } catch (e) {
    return 'خطأ: $e';
  }
}

Future<String?> verifyOtpJs(String code) async {
  final phoneAuth = web.globalThis['_phoneAuth'];
  if (phoneAuth == null) return 'خطأ: Firebase غير محمّل';
  try {
    final dynamic promise = phoneAuth.call('verifyOtp', code);
    await promise;
    return null;
  } catch (e) {
    return 'خطأ: $e';
  }
}