import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
//Database fields initialisation
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

//Create Database
  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print('Creating a new one');
        return db.execute(
          "CREATE TABLE $_tableName("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title STRING, note TEXT, date STRING,"
          "startTime STRING, endTime STRING,"
          "remind INTEGER, repeat STRING,"
          "color INTEGER,"
          "isCompleted INTEGER)",
        );
      });
    } catch (e) {
      print(e);
    }
  }

//Insert data in database
  static Future<int> insert(Task? task) async {
    print('Insert function called');
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

//Fetch data from database
  static Future<List<Map<String, dynamic>>> query() async {
    print('query function called');
    return await _db!.query(_tableName);
  }

//Delete data from database
  static delete(Task task) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

//Update database data
  static update(int id) async {
    return await _db!.rawUpdate(
        ''' UPDATE tasks SET isCompleted = ? WHERE id=? ''', [1, id]);
  }
}
