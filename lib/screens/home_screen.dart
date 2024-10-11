import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todoist/models/home_model.dart';
import 'package:todoist/screens/add_task.dart';
import 'package:todoist/services/api_services.dart';
import 'package:todoist/utils/colors.dart';

class HomeClass extends StatefulWidget {
  const HomeClass({super.key});

  @override
  State<HomeClass> createState() => _HomeClassState();
}

class _HomeClassState extends State<HomeClass> {
  ApiService api = ApiService();
  int? selectedValue = 0;
  bool prioritySelected = false;
  bool filterSelected = false;
  int? sortByPriority;

  final Map<int, String> priorityMap = {
    0: 'Select Priority',
    1: 'High',
    2: 'Medium',
    3: 'Normal',
    4: 'Low'
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Mycolors.primaryColor,
        title: const Text(
          "Tasks List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            hintText: "Select Priority",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        items: priorityMap.entries
                            .map((e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text(e.value),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            prioritySelected = true;
                            selectedValue = val;
                          });
                        }),
                  ),
                  const SizedBox(width: 30),
                  Row(
                    children: [
                      IconButton.filled(
                          onPressed: () {
                            setState(() {
                              filterSelected = true;
                              sortByPriority = 1;
                            });
                          },
                          icon: const Icon(Icons.arrow_upward)),
                      IconButton.filled(
                          onPressed: () {
                            setState(() {
                              filterSelected = true;
                              sortByPriority = 4;
                            });
                          },
                          icon: const Icon(Icons.arrow_downward))
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Tasks",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 15),
              FutureBuilder(
                  future: prioritySelected
                      ? api.getAllTasks(
                          apiUrl, apiKey, selectedValue, prioritySelected)
                      : api.getAllTasks(apiUrl, apiKey, 0, prioritySelected),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<HomeModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xffEEF2FF)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              maxLines: 1,
                                              snapshot.data?[index].content ??
                                                  "No Title",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          PopupMenuButton(
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<int>>[
                                              const PopupMenuItem(
                                                  value: 0,
                                                  child: Text("Complete")),
                                              const PopupMenuItem(
                                                  value: 1,
                                                  child: Text("Edit")),
                                              const PopupMenuItem(
                                                  value: 2,
                                                  child: Text("Delete"))
                                            ],
                                            onSelected: (int value) {},
                                          )
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: snapshot.data?[index]
                                                        .priority ==
                                                    1
                                                ? Mycolors.highPriorityColor
                                                : snapshot.data?[index]
                                                            .priority ==
                                                        2
                                                    ? Mycolors
                                                        .mediumPriorityColor
                                                    : snapshot.data?[index]
                                                                .priority ==
                                                            3
                                                        ? Mycolors
                                                            .normalPriorityColor
                                                        : snapshot.data?[index]
                                                                    .priority ==
                                                                4
                                                            ? Mycolors
                                                                .lowPriorityColor
                                                            : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          '${priorityMap[snapshot.data?[index].priority]}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        maxLines: 4,
                                        snapshot.data?[index].description ??
                                            "No Description",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          return const Center(
                              child: Text(
                            "No Data",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ));
                        }
                      } else {
                        return const Text("Error");
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => AddTask()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
