import 'package:flutter/material.dart';
import 'package:todoist/models/home_model.dart';
import 'package:todoist/screens/home_screen.dart';
import 'package:todoist/services/api_services.dart';
import 'package:todoist/services/api_url.dart';
import 'package:todoist/utils/colors.dart';

class AddTaskClass extends StatefulWidget {
  final bool? isEdit;
  final HomeModel? data;

  const AddTaskClass({super.key, this.isEdit, this.data});

  @override
  State<AddTaskClass> createState() => _AddTaskClassState();
}

class _AddTaskClassState extends State<AddTaskClass> {
  ApiService api = ApiService();
  bool isLoading = false;
  final Map<int, String> priorityMap = {
    0: 'Select Priority',
    1: 'High',
    2: 'Medium',
    3: 'Normal',
    4: 'Low'
  };
  int? selectedValue = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.isEdit ?? false) {
      titleController.text = widget.data?.content ?? "No Title";
      descriptionController.text = widget.data?.description ?? "No Description";
      selectedValue = widget.data?.priority;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        backgroundColor: Mycolors.primaryColor,
        centerTitle: true,
        title: Text(
          widget.isEdit! ? "Edit Task" : "Add Task",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    hintText: "Enter Task Title"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    hintText: "Enter Task Description"),
                minLines: 6,
                maxLines: null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                  value: selectedValue,
                  decoration: const InputDecoration(
                      hintText: "Select Priority",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  items: priorityMap.entries
                      .map((e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedValue = val;
                    });
                  }),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        selectedValue == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Mycolors.primaryColor,
                          content: const Text(
                            "Please Fill the fields",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      HomeModel data = HomeModel(
                          content: titleController.text,
                          description: descriptionController.text,
                          priority: selectedValue,
                          isCompleted: false);
                      if (widget.isEdit!) {
                        await api.updateTask(
                            apiUrl: ApiUrl.apiUrl,
                            apiKey: ApiUrl.apiKey,
                            body: data.toJson(),
                            id: widget.data!.id);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const HomeClass()));
                        isLoading = false;
                      } else {
                        await api.postTask(
                            ApiUrl.apiUrl, ApiUrl.apiKey, data.toJson());
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const HomeClass()));
                        isLoading = false;
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(350, 50),
                      backgroundColor: Mycolors.primaryColor,
                      foregroundColor: Colors.white),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          widget.isEdit! ? "Update Task" : "Add Task",
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
