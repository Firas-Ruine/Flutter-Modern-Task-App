// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, unnecessary_new, sort_child_properties_last, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_with_dark/controllers/task_controller.dart';
import 'package:todo_app_with_dark/models/task.dart';
import 'package:todo_app_with_dark/ui/theme.dart';
import 'package:todo_app_with_dark/ui/widgets/button.dart';
import 'package:todo_app_with_dark/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  //Variable initialisation
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Task",
                  style: headingStyle,
                ),

                //Title input field
                InputField(
                  title: "Title",
                  hint: 'Enter title here.',
                  controller: _titleController,
                ),

                //Note input field
                InputField(
                  title: "Note",
                  hint: 'Enter note here.',
                  controller: _noteController,
                ),

                //Date selector input
                InputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      print("Hi there");
                      _getDateFromUser();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      //Start Date input
                      child: InputField(
                        title: "Start Date",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: Icon(Icons.access_time_rounded),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      //End date input
                      child: InputField(
                        title: "End Date",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: Icon(Icons.access_time_rounded),
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),

                //remind input
                InputField(
                    title: "Remind",
                    hint: "$_selectedRemind minutes early",
                    widget: DropdownButton(
                      onChanged: (String? newValue) => {
                        setState(() {
                          _selectedRemind = int.parse(newValue!);
                        })
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTitleStyle,
                      underline: Container(height: 0),
                      items:
                          remindList.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem(
                          child: Text(value.toString()),
                          value: value.toString(),
                        );
                      }).toList(),
                    )),

                //Repeat input field
                InputField(
                    title: "Repeat",
                    hint: "$_selectedRepeat",
                    widget: DropdownButton(
                      onChanged: (String? newValue) => {
                        setState(() {
                          _selectedRepeat = newValue!;
                        })
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTitleStyle,
                      underline: Container(height: 0),
                      items: repeatList
                          .map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem(
                          child: Text(value!,
                              style: TextStyle(color: Colors.grey)),
                          value: value,
                        );
                      }).toList(),
                    )),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    Button(
                        label: "Create Task",
                        onTap: () {
                          _validateDate();
                        })
                  ],
                )
              ],
            ),
          )),
    );
  }

//Validate date function
  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.isDarkMode
              ? darkHeaderClr
              : Color.fromARGB(255, 255, 253, 244),
          colorText: Colors.red,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

//Add Task to database function
  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0,
    ));
    print("My id is :" + "$value");
  }

//3 circles colors function
  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: _selectedColor == index
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ));
          }),
        )
      ],
    );
  }

//App barr design function
  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 25,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      // ignore: prefer_const_literals_to_create_immutables
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/Logo.png"),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

//Get the date from user function
  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print("it's null or someting is worng");
    }
  }

//Get time from user function
  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('Time Cancelled');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

//Time picker function
  _showTimePicker() {
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
  }
}
