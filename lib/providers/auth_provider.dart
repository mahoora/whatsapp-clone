      if (kIsWeb) {
        String? vid;
        String? err;
        await FirebaseService.auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (cred) async {
            await FirebaseService.auth.signInWithCredential(cred);
          },
          verificationFailed: (e) {
            err = e.message ?? 'فشل إرسال رمز التحقق';
          },
          codeSent: (v, _) {
            vid = v;
          },
          codeAutoRetrievalTimeout: (_) {},
          timeout: const Duration(seconds: 60),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (err != null) {
          _error = err;
        } else {
          _verificationId = vid;
        }
      }