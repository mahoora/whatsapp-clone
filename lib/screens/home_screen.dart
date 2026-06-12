import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../services/firebase_service.dart';
import '../models/chat_model.dart';
import '../widgets/chat_list_widget.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 768;
    final chatProv = context.watch<ChatProvider>();
    final showChat = chatProv.selectedChatId != null;

    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      body: SafeArea(
        child: isWide ? _buildWideLayout() : _buildNarrowLayout(showChat),
      ),
    );
  }

  Widget _buildWideLayout() {
    final chatProv = context.watch<ChatProvider>();

    return Row(
      children: [
        SizedBox(
          width: 400,
          child: _buildChatListPanel(),
        ),
        const VerticalDivider(width: 1, color: Color(0xFF313D45)),
        Expanded(
          child: chatProv.selectedChatId == null
              ? _buildWelcomePanel()
              : ChatScreen(
                  chatId: chatProv.selectedChatId!,
                  chatName: chatProv.selectedChatName!,
                  avatar: chatProv.selectedAvatar!,
                ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(bool showChat) {
    if (showChat) {
      final chatProv = context.watch<ChatProvider>();
      return ChatScreen(
        chatId: chatProv.selectedChatId!,
        chatName: chatProv.selectedChatName!,
        avatar: chatProv.selectedAvatar!,
        onBack: () => context.read<ChatProvider>().clearSelection(),
      );
    }
    return _buildChatListPanel();
  }

  Widget _buildChatListPanel() {
    final auth = context.watch<AuthProvider>();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFF202C33),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF00A884),
                child: Text(
                  (auth.appUser?.displayName ?? 'U')[0].toUpperCase(),
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  auth.appUser?.displayName ?? 'WhatsApp',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE9EDEF)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chat, color: Color(0xFF8696A0)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Color(0xFF8696A0)),
                onPressed: () => auth.logout(),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFF111B21),
          child: TextField(
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 14),
            decoration: InputDecoration(
              hintText: 'ابحث أو ابدأ محادثة جديدة',
              hintStyle: const TextStyle(color: Color(0xFF8696A0)),
              hintTextDirection: TextDirection.rtl,
              prefixIcon: const Icon(Icons.search, color: Color(0xFF8696A0), size: 20),
              filled: true,
              fillColor: const Color(0xFF202C33),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseService.firestore
                .collection('chats')
                .orderBy('lastMessageAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFF8696A0)),
                      const SizedBox(height: 8),
                      Text('خطأ: ${snapshot.error}', style: const TextStyle(color: Color(0xFF8696A0), fontSize: 13)),
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF00A884)));
              }
              final chats = snapshot.data?.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ChatModel.fromMap(data, doc.id);
              }).toList() ?? [];

              return ChatListWidget(
                chats: chats,
                selectedId: context.watch<ChatProvider>().selectedChatId,
                onChatTap: (id, name, avatar) {
                  context.read<ChatProvider>().selectChat(id, name, avatar);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomePanel() {
    return Container(
      color: const Color(0xFF222E35),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF202C33),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(Icons.chat, size: 60, color: Color(0xFF8696A0)),
            ),
            const SizedBox(height: 24),
            const Text('WhatsApp Clone', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: Color(0xFFE9EDEF))),
            const SizedBox(height: 8),
            const Text('اختر محادثة لبدء المراسلة', style: TextStyle(fontSize: 14, color: Color(0xFF8696A0))),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: const Color(0xFF182229),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF313D45)),
              ),
              child: const Text(
                'اضغط على محادثة من القائمة اليسرى لبدء المراسلة\nأو استخدم زر الدردشة لبدء محادثة جديدة',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF8696A0), fontSize: 13, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
