import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.uid,
    super.name,
    super.email,
    super.profilURL,
    super.password,
    super.phone,
    super.role = 'Locataire',
    super.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    DateTime? createdAt;
    final rawCreatedAt = data['createdAt'];
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt);
    }

    return UserModel(
      uid: (data['uid'] as String?) ?? doc.id,
      name: data['name'] as String?,
      email: data['email'] as String?,
      profilURL: data['profilURL'] as String?,
      phone: data['phone'] as String?,
      role: (data['role'] as String?) ?? 'Locataire',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name ?? '',
      'email': email ?? '',
      'profilURL': profilURL,
      'phone': phone,
      'role': role,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    final rawCreatedAt = json['createdAt'];
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt);
    } else if (rawCreatedAt is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(rawCreatedAt);
    }

    return UserModel(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profilURL: json['profilURL'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      role: (json['role'] as String?) ?? 'Locataire',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilURL': profilURL,
      'password': password,
      'phone': phone,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      profilURL: entity.profilURL,
      password: entity.password,
      phone: entity.phone,
      role: entity.role,
      createdAt: entity.createdAt,
    );
  }

  factory UserModel.fromFirebaseAuth(User user) {
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      profilURL: user.photoURL,
      phone: user.phoneNumber,
      role: 'Locataire',
      createdAt: user.metadata.creationTime,
    );
  }
}
