class Task {
  final int id;
  final String title;
  final String? description;
  final String? dueDate;

  Task({required this.id, required this.title, this.description, this.dueDate});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['due_date'],
    );
  }
}