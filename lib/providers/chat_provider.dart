import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ChatProvider extends ChangeNotifier {
  String? _selectedChatId;
  String? _selectedChatName;
  String? _selectedAvatar;

  String? get selectedChatId => _selectedChatId;
  String? get selectedChatName => _selectedChatName;
  String? get selectedAvatar => _selectedAvatar;

  void selectChat(String id, String name, String avatar) {
    _selectedChatId = id;
    _selectedChatName = name;
    _selectedAvatar = avatar;
    notifyListeners();
  }

  void clearSelection() {
    _selectedChatId = null;
    _selectedChatName = null;
    _selectedAvatar = null;
    notifyListeners();
  }

  Stream<QuerySnapshot> getChatsStream() {
    return FirebaseService.firestore
        .collection('chats')
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return FirebaseService.firestore
        .collection('chats').doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage(String chatId, String text, String senderId, String senderName) async {
    final msg = MessageModel(
      id: '',
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      type: 'text',
      timestamp: DateTime.now(),
      isSent: true,
    );

    final batch = FirebaseService.firestore.batch();
    final msgRef = FirebaseService.messages(chatId).doc();
    batch.set(msgRef, msg.toMap());

    final now = DateTime.now();
    batch.update(
      FirebaseService.firestore.collection('chats').doc(chatId),
      {
        'lastMessage': text,
        'lastMessageAt': Timestamp.fromDate(now),
        'time': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      },
    );

    await batch.commit();
  }

  Future<String> createChat(List<String> participants, String name, String avatar) async {
    final doc = await FirebaseService.firestore.collection('chats').add({
      'name': name,
      'participants': participants,
      'avatar': avatar,
      'lastMessage': 'بدأت محادثة جديدة',
      'time': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
      'unread': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await FirebaseService.firestore
        .collection('chats').doc(chatId)
        .collection('messages').doc(messageId)
        .delete();
  }

  Future<List<AppUser>> searchUsers(String query) async {
    final snapshot = await FirebaseService.firestore
        .collection('users')
        .orderBy('displayName')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .get();
    return snapshot.docs
        .map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
