import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final String avatar;
  final List<String> participants;
  final DateTime? lastMessageAt;

  ChatModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    required this.avatar,
    this.participants = const [],
    this.lastMessageAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatModel(
      id: docId,
      name: map['name'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      time: map['time'] ?? '',
      unread: map['unread'] ?? 0,
      avatar: map['avatar'] ?? '?',
      participants: List<String>.from(map['participants'] ?? []),
      lastMessageAt: (map['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
      'unread': unread,
      'avatar': avatar,
      'participants': participants,
      'lastMessageAt': lastMessageAt != null ? Timestamp.fromDate(lastMessageAt!) : null,
    };
  }
}
