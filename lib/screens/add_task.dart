import 'package:flutter/material.dart';
import 'package:todoist/models/home_model.dart';
import 'package:todoist/screens/home_screen.dart';
import 'package:todoist/services/api_services.dart';
import 'package:todoist/utils/colors.dart';

class AddTask extends StatefulWidget {
  bool? isEdit;
  String? content;
  String? description;
  int? priority;
  String? id;
  AddTask(
      {super.key,
      this.content,
      this.description,
      this.priority,
      this.isEdit,
      this.id});

  @override
  State<AddTask> createState() => _AddTaskState();
}

var apiUrl = "https://api.todoist.com/rest/v2/tasks";
var apiKey = "ee30b5759efde41eebf0b6126018b043bd016215";
ApiService api = ApiService();
TextEditingController inputController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
int? selectedValue = 1;

class _AddTaskState extends State<AddTask> {
  @override
  void initState() {
    if (widget.isEdit!) {
      inputController.text = "${widget.content}";
      descriptionController.text = "${widget.description}";
      selectedValue = widget.priority;
    } else {
      widget.isEdit = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Mycolors.primaryColor,
        ),
        body: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "Enter Title"),
              controller: inputController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: "Enter Description"),
              controller: descriptionController,
            ),
            DropdownButton(
              value: selectedValue,
              onChanged: (val) {
                setState(() {
                  selectedValue = val;
                });
              },
              items: [1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (widget.isEdit!) {
                    HomeModel data = HomeModel(
                        content: inputController.text,
                        description: descriptionController.text,
                        priority: selectedValue);
                    await api.updateTask(
                        apiUrl: apiUrl,
                        apiKey: apiKey,
                        body: data.toJson(),
                        id: widget.id);
                    widget.isEdit = false;
                  } else {
                    if (inputController.text.isNotEmpty) {
                      HomeModel data = HomeModel(
                          content: inputController.text,
                          description: descriptionController.text,
                          priority: selectedValue);
                      await api.postTask(apiUrl, apiKey, data.toJson());
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const HomeClass()));
                    }
                  }
                },
                child: Text(widget.isEdit! ? "Edit Task" : "Add Task"))
          ],
        ));
  }
}














