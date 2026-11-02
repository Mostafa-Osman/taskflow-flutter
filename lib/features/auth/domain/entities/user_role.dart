enum UserRole {
  teacher,
  assistant;

  String get apiValue => name;

  static UserRole fromApi(String? value) {
    return switch (value) {
      'assistant' => UserRole.assistant,
      _ => UserRole.teacher,
    };
  }
}
