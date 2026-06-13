import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final DateTime time;
  final bool isRead;
  final VoidCallback? onDelete;
  final VoidCallback? onCopy;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
    this.onDelete,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF1F2C33),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (ctx) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.copy, color: Color(0xFFE9EDEF)),
                          title: const Text('نسخ', style: TextStyle(color: Color(0xFFE9EDEF))),
                          onTap: () { Navigator.pop(ctx); onCopy?.call(); },
                        ),
                        if (isMe)
                          ListTile(
                            leading: const Icon(Icons.delete_outline, color: Color(0xFFE9EDEF)),
                            title: const Text('حذف', style: TextStyle(color: Color(0xFFE9EDEF))),
                            onTap: () { Navigator.pop(ctx); onDelete?.call(); },
                          ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF005C4B) : const Color(0xFF202C33),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(8),
                  topRight: const Radius.circular(8),
                  bottomLeft: isMe ? const Radius.circular(8) : const Radius.circular(0),
                  bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 15),
                    textDirection: ui.TextDirection.rtl,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(time),
                        style: const TextStyle(fontSize: 11, color: Color(0xFF8696A0)),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          isRead ? Icons.done_all : Icons.done,
                          size: 16,
                          color: isRead ? const Color(0xFF53BDEB) : const Color(0xFF8696A0),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
