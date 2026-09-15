import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_session.dart';
import 'user_dto.dart';

part 'auth_response_dto.g.dart';

@JsonSerializable()
class AuthResponseDto {
  const AuthResponseDto({required this.token, required this.user});

  final String token;
  final UserDto user;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseDtoToJson(this);

  AuthSession toEntity() => AuthSession(token: token, user: user.toEntity());
}
