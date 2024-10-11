class HomeModel {
  String? id;
  String? content;
  String? description;
  int? priority;
  bool? isCompleted;

  HomeModel(
      {this.id,
      this.content,
      this.description,
      this.priority,
      this.isCompleted});

  HomeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    description = json['description'];
    priority = json['priority'];
    isCompleted = json['is_completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['description'] = description;
    data['priority'] = priority;
    data['is_completed'] = isCompleted;
    return data;
  }
}
