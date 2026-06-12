import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_model.dart';

class ChatListWidget extends StatelessWidget {
  final List<ChatModel> chats;
  final String? selectedId;
  final void Function(String id, String name, String avatar) onChatTap;

  const ChatListWidget({
    super.key,
    required this.chats,
    this.selectedId,
    required this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.message_outlined, size: 64, color: Color(0xFF313D45)),
            const SizedBox(height: 12),
            const Text('لا توجد محادثات بعد', style: TextStyle(color: Color(0xFF8696A0), fontSize: 16)),
            const SizedBox(height: 8),
            const Text('ابدأ محادثة جديدة', style: TextStyle(color: Color(0xFF313D45), fontSize: 13)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFF313D45), indent: 72),
      itemBuilder: (context, index) {
        final chat = chats[index];
        final isSelected = chat.id == selectedId;
        return InkWell(
          onTap: () => onChatTap(chat.id, chat.name, chat.avatar),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isSelected ? const Color(0xFF2A3942) : Colors.transparent,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: _avatarColor(chat.name),
                  child: Text(
                    chat.avatar,
                    style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              chat.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFE9EDEF)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(chat.lastMessageAt),
                            style: const TextStyle(fontSize: 12, color: Color(0xFF8696A0)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF8696A0)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (chat.unread > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00A884),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                chat.unread > 99 ? '99+' : '${chat.unread}',
                                style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _avatarColor(String name) {
    final colors = [
      const Color(0xFF00A884), const Color(0xFF5B67CA),
      const Color(0xFFD4A04A), const Color(0xFFE6556B),
      const Color(0xFF4F9DE6), const Color(0xFFCB6D4A),
      const Color(0xFF6BBF7A), const Color(0xFFA06BBF),
    ];
    final hash = name.codeUnits.fold<int>(0, (prev, c) => prev + c);
    return colors[hash % colors.length];
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return DateFormat('HH:mm').format(dt);
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) {
      switch (dt.weekday) {
        case 1: return 'الإثنين';
        case 2: return 'الثلاثاء';
        case 3: return 'الأربعاء';
        case 4: return 'الخميس';
        case 5: return 'الجمعة';
        case 6: return 'السبت';
        case 7: return 'الأحد';
        default: return '';
      }
    }
    return '${dt.day}/${dt.month}';
  }
}
