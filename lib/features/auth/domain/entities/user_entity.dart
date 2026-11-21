import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? name;
  final String? email;
  final String? profilURL;
  final String? password;
  final String? phone;
  final String role;
  final DateTime? createdAt;

  const UserEntity({
    this.uid,
    this.name,
    this.email,
    this.profilURL,
    this.password,
    this.phone,
    this.role = 'Locataire',
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        profilURL,
        password,
        phone,
        role,
        createdAt,
      ];
}
