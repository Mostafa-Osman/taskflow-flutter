class Project {
  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.taskCount,
    required this.completedTaskCount,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final int taskCount;
  final int completedTaskCount;
  final DateTime updatedAt;

  double get progress => taskCount == 0 ? 0 : completedTaskCount / taskCount;
}
