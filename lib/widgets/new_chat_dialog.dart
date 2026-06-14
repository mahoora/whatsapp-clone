import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';

class NewChatDialog extends StatefulWidget {
  const NewChatDialog({super.key});

  @override
  State<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<NewChatDialog> {
  final _searchCtrl = TextEditingController();
  List<AppUser> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }
    setState(() => _isSearching = true);
    final snapshot = await FirebaseService.firestore
        .collection('users')
        .orderBy('displayName')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(20)
        .get();
    setState(() {
      _results = snapshot.docs
          .map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: const Color(0xFF1F2C33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF313D45))),
                ),
                child: Row(
                  children: [
                    const Text(
                      'محادثة جديدة',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE9EDEF)),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF8696A0)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم المستخدم...',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: const TextStyle(color: Color(0xFF8696A0)),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF8696A0)),
                    filled: true,
                    fillColor: const Color(0xFF2A3942),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onChanged: _search,
                ),
              ),
              Flexible(
                child: _isSearching
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF00A884)))
                    : _results.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person_search, size: 48, color: Color(0xFF313D45)),
                                const SizedBox(height: 8),
                                Text(
                                  _searchCtrl.text.isEmpty ? 'اكتب اسم المستخدم للبحث' : 'لا توجد نتائج',
                                  style: const TextStyle(color: Color(0xFF8696A0)),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final user = _results[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: const Color(0xFF00A884),
                                  child: Text(
                                    user.displayName[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(user.displayName, style: const TextStyle(color: Color(0xFFE9EDEF))),
                                subtitle: Text(
                                  user.status ?? 'مرحباً، أنا على واتساب',
                                  style: const TextStyle(color: Color(0xFF8696A0), fontSize: 13),
                                ),
                                onTap: () => _startChat(user),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startChat(AppUser otherUser) async {
    final auth = context.read<AuthProvider>();
    final chatProv = context.read<ChatProvider>();
    final participants = [auth.userId, otherUser.uid]..sort();
    final chatId = participants.join('_');
    final doc = await FirebaseService.firestore.collection('chats').doc(chatId).get();
    if (!doc.exists) {
      await chatProv.createChat(chatId, participants, otherUser.displayName, otherUser.displayName[0].toUpperCase());
    }
    if (context.mounted) {
      Navigator.pop(context);
      chatProv.selectChat(chatId, otherUser.displayName, otherUser.displayName[0].toUpperCase());
    }
  }
}
