// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressModel _$AddressModelFromJson(Map<String, dynamic> json) =>
    _AddressModel(
      label: json['label'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      zip: json['zip'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$AddressModelToJson(_AddressModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'street': instance.street,
      'city': instance.city,
      'zip': instance.zip,
      'isDefault': instance.isDefault,
    };

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  photoUrl: json['photoUrl'] as String?,
  addresses:
      (json['addresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  wishlist:
      (json['wishlist'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  isBlocked: json['isBlocked'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'photoUrl': instance.photoUrl,
      'addresses': instance.addresses,
      'wishlist': instance.wishlist,
      'createdAt': instance.createdAt.toIso8601String(),
      'isBlocked': instance.isBlocked,
    };
