import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todoist/models/home_model.dart';

class ApiService {
  Future<List<HomeModel>> getAllTasks(
      apiUrl, apiKey, priority, prioritySelected) async {
    List<HomeModel> tasksList = [];
    var response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    });
    var responseBody = jsonDecode(response.body);
    for (var item in responseBody) {
      if (prioritySelected) {
        if (item['priority'] == priority) {
          tasksList.add(HomeModel.fromJson(item));
        } else if (priority == 0) {
          tasksList.add(HomeModel.fromJson(item));
        }
      } else {
        tasksList.add(HomeModel.fromJson(item));
      }
    }

    return tasksList;
  }

  postTask(apiUrl, apiKey, body) async {
    await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey"
        },
        body: jsonEncode(body));
  }

  updateTask(
      {required apiUrl, required apiKey, required body, required id}) async {
    var url = Uri.parse('$apiUrl/$id');

    await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey"
        },
        body: jsonEncode(body));
  }

  deleteTask({required apiUrl, required apiKey, required id}) async {
    var url = Uri.parse('$apiUrl/$id');
    await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      },
    );
  }
}
