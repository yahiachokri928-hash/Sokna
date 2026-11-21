import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/features/auth/data/models/user_model.dart';
import 'package:sokna/features/auth/domain/entities/user_entity.dart';

void main() {
  final tDateTime = DateTime(2026, 1, 15);
  final tUserModel = UserModel(
    uid: 'user_123',
    name: 'Yahia Chokri',
    email: 'yahia@example.com',
    profilURL: 'https://example.com/avatar.jpg',
    password: 'password123',
    phone: '+216 20 123 456',
    role: 'Locataire',
    createdAt: tDateTime,
  );

  test('UserModel should be a subclass of UserEntity', () {
    expect(tUserModel, isA<UserEntity>());
  });

  group('fromJson and toJson', () {
    test('fromJson should return valid UserModel from json map', () {
      final json = {
        'uid': 'user_123',
        'name': 'Yahia Chokri',
        'email': 'yahia@example.com',
        'profilURL': 'https://example.com/avatar.jpg',
        'password': 'password123',
        'phone': '+216 20 123 456',
        'role': 'Locataire',
        'createdAt': tDateTime.toIso8601String(),
      };

      final result = UserModel.fromJson(json);

      expect(result.uid, 'user_123');
      expect(result.name, 'Yahia Chokri');
      expect(result.role, 'Locataire');
      expect(result.phone, '+216 20 123 456');
    });

    test('toJson should return correct map with all fields', () {
      final json = tUserModel.toJson();

      expect(json['uid'], 'user_123');
      expect(json['name'], 'Yahia Chokri');
      expect(json['role'], 'Locataire');
      expect(json['phone'], '+216 20 123 456');
      expect(json['createdAt'], tDateTime.toIso8601String());
    });
  });

  group('fromEntity', () {
    test('fromEntity should convert UserEntity to UserModel', () {
      const entity = UserEntity(
        uid: 'user_456',
        name: 'Sami Ben Ali',
        email: 'sami@example.com',
        role: 'Propriétaire',
        phone: '+216 98 765 432',
      );

      final result = UserModel.fromEntity(entity);

      expect(result.uid, 'user_456');
      expect(result.role, 'Propriétaire');
      expect(result.phone, '+216 98 765 432');
    });
  });
}
