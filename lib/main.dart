import 'package:analog_clock/analog_clock.dart';
import 'package:todoooo/constants.dart';
import 'package:todoooo/database.dart';
import 'constants.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todoooo/Splashscreen.dart';
import 'package:todoooo/TaskModel.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'To-do',
      home: SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<Todo> taskList = [];
  TextEditingController textController = new TextEditingController();

  String newTaskTitle;

  @override
  void initState() {
    super.initState();

    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          taskList.add(Todo(id: element['id'], title: element["title"]));
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.APP_BG_COLOR,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Vibration.vibrate(duration: 30, amplitude: 50);
            Get.bottomSheet(
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: AppColors.APP_BG_COLOR,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                height: Get.height / 2,
                width: Get.width,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(
                        child: Text(
                      'Add Task',
                      style: TextStyle(
                        fontSize: 40,
                        color: AppColors.TextColour,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    )),
                    SizedBox(height: 30),
                    TextField(
                        controller: textController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.TextColour, fontSize: 20),
                        showCursor: false,
                        autofocus: true,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: AppColors.App_COMPLIMENTARY,
                              width: 1,
                            )),
                            hintText: 'Enter Your Task',
                            hintStyle: TextStyle(color: Colors.white60)),
                        onChanged: (newText) {
                          newTaskTitle = newText;
                        }),
                    SizedBox(
                      height: Get.height / 5,
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        Vibration.vibrate(duration: 30, amplitude: 50);
                        if (newTaskTitle != null) {
                          _addToDb();
                          Get.back();
                        } else {
                          Get.defaultDialog(
                              confirm: IconButton(
                                icon: Icon(
                                  Icons.done,
                                  color: AppColors.appTheme,
                                ),
                                onPressed: () => Get.back(),
                                iconSize: 40,
                              ),
                              title: 'ERROR',
                              textConfirm: 'OK',
                              middleText: 'Text Field is Empty');
                        }
                      },
                      label: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      icon: Icon(
                        FontAwesomeIcons.plusCircle,
                        size: 20,
                      ),
                      backgroundColor: AppColors.appTheme,
                    ),
                  ],
                ),
              ),
            );
          },
          child: Icon(FontAwesomeIcons.plus),
          backgroundColor: AppColors.App_COMPLIMENTARY,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            CircleAvatar(
              radius: 50,
              child: AnalogClock(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 3.0, color: AppColors.App_COMPLIMENTARY),
                    color: AppColors.APP_BG_COLOR,
                    shape: BoxShape.circle),
                width: 100.0,
                isLive: true,
                hourHandColor: Colors.white,
                minuteHandColor: Colors.white,
                showSecondHand: false,
                numberColor: Colors.white,
                showNumbers: false,
                textScaleFactor: 1,
                showTicks: true,
                showDigitalClock: false,
                datetime: DateTime(2021, 1, 1, 9, 12, 15),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'To-Do',
              style: TextStyle(
                  color: AppColors.TextColour,
                  fontSize: 40,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              taskList.length == 0
                  ? 'Currently No Tasks'
                  : '${taskList.length} Task${taskList.length == 1 ? "" : "s"}',
              style: TextStyle(
                  letterSpacing: 2,
                  color: AppColors.TextColour,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 30,
            ),
            ListView.builder(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actions: [
                      IconSlideAction(
                          caption: 'Delete',
                          color: Colors.transparent,
                          icon: Icons.delete,
                          foregroundColor: AppColors.App_COMPLIMENTARY,
                          onTap: () {
                            _deleteTask(taskList[index].id);
                          }),
                    ],
                    secondaryActions: [
                      IconSlideAction(
                          caption: 'Delete',
                          color: Colors.transparent,
                          icon: Icons.delete,
                          foregroundColor: AppColors.App_COMPLIMENTARY,
                          onTap: () {
                            _deleteTask(taskList[index].id);
                          })
                    ],
                    child: ListTile(
                      subtitle: Divider(
                        color: Colors.white24,
                      ),
                      title: Text(
                        '${taskList[index].title}',
                        style: TextStyle(
                            fontSize: 20,
                            color: taskList[index].isChecked
                                ? AppColors.appTheme
                                : AppColors.TextColour,
                            fontWeight: FontWeight.w600,
                            decoration: taskList[index].isChecked
                                ? TextDecoration.lineThrough
                                : null,
                            fontStyle: taskList[index].isChecked
                                ? FontStyle.italic
                                : FontStyle.normal),
                      ),
                      trailing: CircularCheckBox(
                          value: taskList[index].isChecked,
                          checkColor: Colors.white,
                          activeColor: AppColors.appTheme,
                          inactiveColor: AppColors.App_COMPLIMENTARY,
                          onChanged: (val) => this.setState(() {
                                taskList[index].isChecked =
                                    !taskList[index].isChecked;
                              })),
                      onTap: () {
                        this.setState(() {
                          taskList[index].isChecked =
                              !taskList[index].isChecked;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      taskList.removeWhere((element) => element.id == id);
    });
  }

  void _addToDb() async {
    String task = textController.text;
    var id = await DatabaseHelper.instance.insert(Todo(title: task));
    setState(() {
      taskList.insert(0, Todo(id: id, title: task));
    });
  }
}
