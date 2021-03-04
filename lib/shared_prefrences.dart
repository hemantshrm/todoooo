import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoooo/TaskModel.dart';

class TodoSave {

  readTask() async {
    final prefs = await SharedPreferences.getInstance();
  print(prefs.getString("task"));
    List<TaskModel> task =   List<TaskModel>();
    var taskmodel = jsonDecode(prefs.getString("task")) as List;
    List<TaskModel> tasks = taskmodel.map((tagJson) => TaskModel.fromJson(tagJson)).toList();

    return tasks;
  }

  saveTask(List<TaskModel> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("task", jsonEncode(data));
  }
  deleteTask() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}