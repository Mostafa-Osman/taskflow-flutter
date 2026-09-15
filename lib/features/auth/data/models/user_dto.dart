import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  const UserDto({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  User toEntity() => User(id: id, name: name, email: email);

  factory UserDto.fromEntity(User user) {
    return UserDto(id: user.id, name: user.name, email: user.email);
  }
}
