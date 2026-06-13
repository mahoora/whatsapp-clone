import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyCxgbprb8mvHuWxtW7kev26SXfVabtm_Ag',
      appId: '1:517846157163:web:daa26ae9bde5549fa8ae2e',
      messagingSenderId: '517846157163',
      projectId: 'studio-1264128917-7f1a5',
      authDomain: 'studio-1264128917-7f1a5.firebaseapp.com',
      storageBucket: 'studio-1264128917-7f1a5.firebasestorage.app',
    ),
  );
  runApp(const WhatsAppCloneApp());
}

class WhatsAppCloneApp extends StatelessWidget {
  const WhatsAppCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'WhatsApp Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF00A884),
          scaffoldBackgroundColor: const Color(0xFF111B21),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00A884),
            secondary: Color(0xFF00A884),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF202C33),
            foregroundColor: Color(0xFFE9EDEF),
            elevation: 0,
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isLoading && auth.isAuthenticated) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator(color: Color(0xFF00A884))),
              );
            }
            return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
          },
        ),
      ),
    );
  }
}
