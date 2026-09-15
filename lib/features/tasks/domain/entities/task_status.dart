enum TaskStatus {
  todo,
  inProgress,
  done;

  String get label => switch (this) {
    TaskStatus.todo => 'To do',
    TaskStatus.inProgress => 'In progress',
    TaskStatus.done => 'Done',
  };

  String get apiValue => switch (this) {
    TaskStatus.todo => 'todo',
    TaskStatus.inProgress => 'inProgress',
    TaskStatus.done => 'done',
  };

  static TaskStatus fromApi(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => TaskStatus.todo,
    );
  }
}
