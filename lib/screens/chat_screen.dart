import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../services/firebase_service.dart';
import '../models/message_model.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String chatName;
  final String avatar;
  final VoidCallback? onBack;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.chatName,
    required this.avatar,
    this.onBack,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _msgCtrl.addListener(() {
      final hasText = _msgCtrl.text.isNotEmpty;
      if (hasText != _isComposing) {
        setState(() => _isComposing = hasText);
      }
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();
    _focusNode.requestFocus();

    final auth = context.read<AuthProvider>();
    final uid = auth.userId;
    final name = auth.appUser?.displayName ?? 'مستخدم';

    await context.read<ChatProvider>().sendMessage(widget.chatId, text, uid, name);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;
    final auth = context.watch<AuthProvider>();
    final uid = auth.userId;

    return Column(
      children: [
        _buildAppBar(isWide),
        Expanded(child: _buildMessagesList(uid)),
        _buildInputBar(isWide),
      ],
    );
  }

  Widget _buildAppBar(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 8, vertical: 8),
      color: const Color(0xFF202C33),
      child: Row(
        children: [
          if (!isWide)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFE9EDEF)),
              onPressed: widget.onBack,
            ),
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF00A884),
            child: Text(widget.avatar, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chatName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFE9EDEF))),
                const SizedBox(height: 2),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseService.firestore.collection('users').doc(widget.chatId).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    final data = snapshot.data?.data() as Map<String, dynamic>?;
                    final isOnline = data?['isOnline'] ?? false;
                    return Text(
                      isOnline ? 'متصل الآن' : 'غير متصل',
                      style: TextStyle(fontSize: 12, color: isOnline ? const Color(0xFF00A884) : const Color(0xFF8696A0)),
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.attach_file, color: Color(0xFF8696A0)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Color(0xFF8696A0)), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildMessagesList(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.firestore
          .collection('chats').doc(widget.chatId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Color(0xFF8696A0)),
                const SizedBox(height: 8),
                Text('خطأ في تحميل الرسائل', style: const TextStyle(color: Color(0xFF8696A0))),
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00A884)));
        }

        final messages = snapshot.data?.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return MessageModel.fromMap(data, doc.id);
        }).toList() ?? [];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollCtrl.hasClients) {
            _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
          }
        });

        if (messages.isEmpty) {
          return Container(
            color: const Color(0xFF0B141A),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF202C33),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.lock_outline, size: 40, color: Color(0xFF8696A0)),
                  ),
                  const SizedBox(height: 16),
                  const Text('الرسائل مشفرة', style: TextStyle(color: Color(0xFF8696A0), fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('أرسل رسالة لبدء المحادثة', style: TextStyle(fontSize: 13, color: Color(0xFF313D45))),
                ],
              ),
            ),
          );
        }

        return Container(
          color: const Color(0xFF0B141A),
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final showDate = index == 0 || _isDifferentDay(messages[index - 1].timestamp, msg.timestamp);
              return Column(
                children: [
                  if (showDate) _buildDateSeparator(msg.timestamp),
                  MessageBubble(
                    text: msg.text,
                    isMe: msg.senderId == uid,
                    time: msg.timestamp,
                    isRead: msg.isRead,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDateSeparator(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    String label;
    if (diff.inDays == 0) label = 'اليوم';
    else if (diff.inDays == 1) label = 'أمس';
    else label = DateFormat('dd/MM/yyyy').format(dt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF182229),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF8696A0))),
        ),
      ),
    );
  }

  Widget _buildInputBar(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 8, vertical: 8),
      color: const Color(0xFF202C33),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions, color: Color(0xFF8696A0)),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _msgCtrl,
              focusNode: _focusNode,
              textInputAction: TextInputAction.send,
              textDirection: ui.TextDirection.rtl,
              onSubmitted: (_) => _sendMessage(),
              style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 15),
              decoration: InputDecoration(
                hintText: 'اكتب رسالة...',
                hintTextDirection: ui.TextDirection.rtl,
                hintStyle: const TextStyle(color: Color(0xFF8696A0)),
                filled: true,
                fillColor: const Color(0xFF2A3942),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isComposing ? _sendMessage : null,
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: _isComposing ? const Color(0xFF00A884) : const Color(0xFF2A3942),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isComposing ? Icons.send : Icons.mic,
                color: _isComposing ? Colors.white : const Color(0xFF8696A0),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isDifferentDay(DateTime a, DateTime b) {
    return a.day != b.day || a.month != b.month || a.year != b.year;
  }
}
