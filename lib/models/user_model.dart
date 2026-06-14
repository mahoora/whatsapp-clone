class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final String? status;
  final bool isOnline;
  final DateTime? lastSeen;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.status,
    this.isOnline = false,
    this.lastSeen,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
      status: map['status'] ?? 'مرحباً، أنا على واتساب',
      isOnline: map['isOnline'] ?? false,
      lastSeen: map['lastSeen'] != null
          ? (map['lastSeen'] is String
              ? DateTime.tryParse(map['lastSeen'])
              : (map['lastSeen'] as dynamic)?.toDate())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'status': status ?? 'مرحباً، أنا على واتساب',
      'isOnline': isOnline,
      'lastSeen': lastSeen,
    };
  }
}
