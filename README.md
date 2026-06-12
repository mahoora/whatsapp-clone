# WhatsApp Clone - واتساب كلون

تطبيق محادثات فوري (ماسنجر) مبني بـ Flutter + Firebase، يدعم **الويب** و **أندرويد** و **آيفون** بكود واحد.

## المميزات

- ✅ تسجيل دخول / إنشاء حساب (Firebase Auth)
- ✅ قائمة محادثات مباشرة (Realtime Stream)
- ✅ إرسال واستقبال رسائل فورية (Firestore StreamBuilder)
- ✅ فقاعات رسائل (يمين للمرسل / يسار للمستقبل)
- ✅ علامات القراءة (✓✓)
- ✅ فصل التاريخ بين الرسائل
- ✅ **Split Screen** على الويب (قائمة شمال + محادثة يمين) زي واتساب ويب
- ✅ واجهة كاملة بالعربي (RTL)
- ✅ التصميم الداكن (Dark Theme) زي واتساب بالضبط

---

## المتطلبات

- **Flutter SDK** (الإصدار 3.0+)
- **Firebase Project** (حساب مجاني)
- **Node.js** (اختياري - لتشغيل Firebase Emulators)

## خطوات التشغيل

### 1. تحميل Flutter SDK

```bash
# حمل Flutter SDK من الموقع الرسمي:
# https://docs.flutter.dev/get-started/install

# بعد التحميل، شوف إذا اشتغل:
flutter doctor
```

### 2. إنشاء Firebase Project

1. روح على https://console.firebase.google.com
2. اضغط **"إضافة مشروع"** وسميه مثلاً `whatsapp-clone`
3. عطل Google Analytics (مش محتاجينه)
4. بعد ما يتخلق:

#### تفعيل Authentication
- من القائمة اليسرى: **Authentication** ← **Sign-in method**
- فعّل **Email/Password**

#### تفعيل Firestore Database
- من القائمة اليسرى: **Firestore Database** ← **إنشاء قاعدة بيانات**
- اختر **الوضع التجريبي** (test mode) عشان تختبر
- المنطقة: اختر أقرب منطقة لك

#### تفعيل Storage (اختياري - للصور)
- من القائمة اليسرى: **Storage** ← **بدء**

### 3. إعداد Firebase في المشروع

#### للويب (Web):
1. في Firebase Console: اضغط على **أيقونة الويب** (</>)
2. سجل التطبيق وانسخ الـ config
3. افتح الملف `C:\Users\maher\OneDrive\المستندات\aopn cod2\web\index.html`
4. استبدل القيم في `firebaseConfig`:

```javascript
const firebaseConfig = {
  apiKey: "API_KEY_BTA3EK",
  authDomain: "PROJECT_ID.firebaseapp.com",
  projectId: "PROJECT_ID",
  storageBucket: "PROJECT_ID.appspot.com",
  messagingSenderId: "SENDER_ID",
  appId: "APP_ID"
};
```

#### لأندرويد (Android):
1. في Firebase Console: اضغط على **أيقونة أندرويد**
2. اسم الحزمة: `com.whatsapp.clone`
3. حمل ملف `google-services.json`
4. ضعه في `C:\Users\maher\OneDrive\المستندات\aopn cod2\android\app\`

#### لآيفون (iOS):
1. في Firebase Console: اضغط على **أيقونة iOS**
2. Apple Bundle ID: `com.whatsapp.clone`
3. حمل ملف `GoogleService-Info.plist`
4. ضعه في `C:\Users\maher\OneDrive\المستندات\aopn cod2\ios\Runner\`

### 4. تعديل Firebase Options في الكود

افتح الملف `lib\main.dart` واستبدل القيم في `FirebaseOptions`:

```dart
await Firebase.initializeApp(
  options: FirebaseOptions(
    apiKey: 'API_KEY_BTA3EK',
    appId: 'APP_ID_BTA3EK',
    messagingSenderId: 'SENDER_ID',
    projectId: 'PROJECT_ID',
    authDomain: 'PROJECT_ID.firebaseapp.com',
    storageBucket: 'PROJECT_ID.appspot.com',
  ),
);
```

### 5. تشغيل المشروع

#### تشغيل على الويب:
```bash
flutter pub get
flutter run -d chrome
```

#### تشغيل على أندرويد:
```bash
flutter pub get
flutter run
```

#### تشغيل على آيفون:
```bash
flutter pub get
cd ios && pod install && cd ..
flutter run
```

## هيكل المشروع

```
aopn cod2/
├── lib/
│   ├── main.dart                    # نقطة الدخول + Firebase init
│   ├── models/
│   │   ├── message_model.dart       # موديل الرسالة
│   │   ├── chat_model.dart          # موديل المحادثة
│   │   └── user_model.dart          # موديل المستخدم
│   ├── services/
│   │   └── firebase_service.dart    # Firebase API calls
│   ├── providers/
│   │   ├── auth_provider.dart       # حالة تسجيل الدخول
│   │   └── chat_provider.dart       # حالة المحادثات
│   ├── screens/
│   │   ├── login_screen.dart        # شاشة الدخول/التسجيل
│   │   ├── home_screen.dart         # الشاشة الرئيسية
│   │   └── chat_screen.dart         # شاشة المحادثة
│   └── widgets/
│       ├── chat_list_widget.dart     # قائمة المحادثات
│       └── message_bubble.dart      # فقاعة الرسالة
├── web/
│   ├── index.html                   # صفحة الويب + Firebase CDN
│   └── manifest.json                # PWA manifest
├── android/
│   └── app/
│       └── src/main/
│           └── AndroidManifest.xml
├── ios/
│   └── Runner/
│       └── Info.plist
├── pubspec.yaml                     # الاعتماديات
└── README.md
```

## الألوان المستخدمة

| اللون | الاستخدام | Hex |
|-------|-----------|-----|
 | أخضر واتساب | الأزرار، الشعار، العلامات | `#00A884` |
 | خلفية الدردشة | خلفية المحادثات | `#0B141A` |
 | خلفية التطبيق | الخلفية الرئيسية | `#111B21` |
 | شريط الأدوات | AppBar, Header | `#202C33` |
 | فقاعة الآخر | رسائل الطرف الآخر | `#202C33` |
 | فقاعة المستخدم | رسائلي | `#005C4B` |
 | عنصر محدد | خلفية الشات المحدد | `#2A3942` |
 | نص رئيسي | عناوين ونصوص | `#E9EDEF` |
 | نص ثانوي | تفاصيل وأماكن | `#8696A0` |

## ملاحظات

- **Firebase Security Rules**: بعد الاختبار، فعّل قواعد الأمان الحقيقية
- **الصور**: إرسال الصور يحتاج تفعيل Firebase Storage و image_picker package
- **الإشعارات**: محتاجة Firebase Cloud Messaging (FCM) + permission handling
