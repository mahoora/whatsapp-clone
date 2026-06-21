import 'dart:js' as js;

Future<String?> sendPhoneOtpJs(String phone) async {
  final phoneAuth = js.context['_phoneAuth'];
  if (phoneAuth == null) return 'Firebase not loaded';
  try {
    final promise = phoneAuth.callMethod('sendOtp', [phone]);
    final result = await promise;
    return result;
  } catch (e) {
    return 'خطأ: $e';
  }
}

Future<String?> verifyOtpJs(String code) async {
  final phoneAuth = js.context['_phoneAuth'];
  if (phoneAuth == null) return 'Firebase not loaded';
  try {
    final promise = phoneAuth.callMethod('verifyOtp', [code]);
    await promise;
    return null;
  } catch (e) {
    return 'خطأ: $e';
  }
}