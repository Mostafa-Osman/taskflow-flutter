enum TaskPriority {
  low,
  medium,
  high;

  String get label => switch (this) {
    TaskPriority.low => 'Low',
    TaskPriority.medium => 'Medium',
    TaskPriority.high => 'High',
  };

  String get apiValue => name;

  static TaskPriority fromApi(String value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.apiValue == value,
      orElse: () => TaskPriority.medium,
    );
  }
}
