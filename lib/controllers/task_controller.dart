// ignore_for_file: unnecessary_new

import 'package:get/get.dart';
import 'package:todo_app_with_dark/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {

//onReady pre-built function
  @override
  void onReady() {
    super.onReady();
  }

//Task list 
  var taskList = <Task>[].obs;

//Add task controller function
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

//Load tasks controller function
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

//Delete task controller function
  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
  }

//Mark as completed controller function
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
