import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String label,
    required String street,
    required String city,
    required String zip,
    @Default(false) bool isDefault,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    @Default([]) List<AddressModel> addresses,
    @Default([]) List<String> wishlist,
    required DateTime createdAt,
    @Default(false) bool isBlocked,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    uid: entity.uid,
    name: entity.name,
    email: entity.email,
    phone: entity.phone,
    photoUrl: entity.photoUrl,
    addresses: entity.addresses.map((e) => AddressModel.fromJson(e)).toList(),
    wishlist: entity.wishlist,
    createdAt: entity.createdAt,
    isBlocked: entity.isBlocked,
  );
}

extension UserModelX on UserModel {
  UserEntity toEntity() => UserEntity(
    uid,
    name ?? '',
    email ?? '',
    phone ?? '',
    photoUrl ?? '',
    addresses.map((e) => e.toJson()).toList(),
    wishlist,
    createdAt,
    isBlocked,
  );
}
