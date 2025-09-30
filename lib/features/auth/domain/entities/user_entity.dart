import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final List<Map<String, dynamic>> addresses;
  final List<String> wishlist;
  final DateTime createdAt;
  final bool isBlocked;

  const UserEntity(
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.addresses,
    this.wishlist,
    this.createdAt,
    this.isBlocked,
  );

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    phone,
    photoUrl,
    addresses,
    wishlist,
    createdAt,
    isBlocked,
  ];
}
