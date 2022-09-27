// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_element

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_with_dark/controllers/task_controller.dart';
import 'package:todo_app_with_dark/services/notification_services.dart';
import 'package:todo_app_with_dark/services/theme_services.dart';
import 'package:todo_app_with_dark/ui/add_task_bar.dart';
import 'package:todo_app_with_dark/ui/theme.dart';
import 'package:todo_app_with_dark/ui/widgets/button.dart';
import 'package:todo_app_with_dark/ui/widgets/task_tile.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskController.getTasks();
    NotifyHelper.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 15,
          ),
          _showTasks(),
        ],
      ),
    );
  }

//Load tasks in the home screen
  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (_, index) {
          Task task = _taskController.taskList[index];
          if (task.repeat == 'Daily') {
            DateTime date = Intl.withLocale(
                'en', () => DateFormat.jm().parse(task.startTime.toString()));
            var myTime = DateFormat('HH:mm').format(date);
            NotifyHelper.scheduledNotification(
              flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
              hour: int.parse(myTime.toString().split(':')[0]),
              minutes: int.parse(myTime.toString().split(':')[1]),
              task: task,
            );
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                  child: FadeInAnimation(
                child: Row(children: [
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, task);
                    },
                    child: TaskTile(task),
                  )
                ]),
              )),
            );
          }
          if (task.date == DateFormat.yMd().format(_selectedDate)) {
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                  child: FadeInAnimation(
                child: Row(children: [
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, task);
                    },
                    child: TaskTile(task),
                  )
                ]),
              )),
            );
          } else {
            return Container();
          }
        },
      );
    }));
  }

//Bottom actions buttons
  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color clr,
      required BuildContext context,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
          label,
          style:
              isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
        )),
      ),
    );
  }

//Bottom actions box function
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(children: [
        Container(
          height: 6,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
        ),
        Spacer(),
        task.isCompleted == 1
            ? Container()
            : _bottomSheetButton(
                label: "Task Completed",
                onTap: () {
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                clr: primaryClr,
                context: context),
        _bottomSheetButton(
            label: "Delete Task",
            onTap: () {
              _taskController.delete(task);
              Get.back();
            },
            clr: Colors.red[500]!,
            context: context),
        SizedBox(
          height: 20,
        ),
        _bottomSheetButton(
            label: "Close",
            onTap: () {
              Get.back();
            },
            clr: Colors.red[500]!,
            isClose: true,
            context: context),
        SizedBox(
          height: 15,
        )
      ]),
    ));
  }

//Add date top bar
  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

//Add task button
  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          Button(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => AddTaskPage());
              _taskController.getTasks();
            },
          )
        ],
      ),
    );
  }

//App bar design
  _appBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          NotifyHelper.showBigTextNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Activated Light Theme"
                  : "Activated Dark Theme",
              fln: flutterLocalNotificationsPlugin);
          /*NotifyHelper.scheduledNotification(
              flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);*/
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
          size: 25,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
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
}
