import 'package:todoooo/constants.dart';
import 'constants.dart';
import 'shared_prefrences.dart';
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
  List<TaskModel> tasks = [];
  TodoSave todoSave = TodoSave();
  String newTaskTitle;
  AnimationController _animationController;
  bool isPlaying = false;

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    fetchUserData();
  }

  fetchUserData() async {
    List<TaskModel> savedTasks = await todoSave.readTask();
    tasks.addAll(savedTasks);
    this.setState(() {
      tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.GradientColour1,
              AppColors.GradientColour2,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black26,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Vibration.vibrate(duration: 30, amplitude: 50);
              Get.bottomSheet(
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.BOTTOMSHEETgrad1,
                        AppColors.BOTTOMSHEETgrad2,
                      ],
                    ),
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
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.TextColour, fontSize: 20),
                          showCursor: false,
                          autofocus: true,
                          decoration: InputDecoration(focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 1,)),
                            hintText: 'Enter Your Task',hintStyle: TextStyle(color: Colors.black26)
                          ),
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
                            setState(() {
                              tasks.add(TaskModel(task: newTaskTitle));
                              newTaskTitle = null;
                              todoSave.deleteTask();
                              todoSave.saveTask(tasks);
                            });
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
            backgroundColor: AppColors.appTheme,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onLongPress: () {
                  _handleOnPressed();
                  Vibration.vibrate(duration: 60, amplitude: 30);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: AnimatedIcon(
                    size: 50,
                    icon: AnimatedIcons.list_view,
                    progress: _animationController,
                    color: AppColors.appTheme,
                  ),
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
                tasks.length == 0
                    ? 'Currently No Tasks'
                    : '${tasks.length} Tasks',
                style: TextStyle(
                    letterSpacing: 2,
                    color: AppColors.TextColour,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actions: [
                            IconSlideAction(
                                caption: 'Delete',
                                color: Colors.transparent,
                                icon: Icons.delete,
                                onTap: () {
                                  tasks.removeAt(index);
                                  Get.snackbar('Message', 'Task deleted',
                                      icon: Icon(Icons.delete, size: 30),
                                      overlayBlur: 3,
                                      backgroundColor: Colors.white,
                                      isDismissible: true,
                                      margin: EdgeInsets.all(30));
                                  todoSave.deleteTask();
                                  todoSave.saveTask(tasks);
                                  this.setState(() {
                                    tasks = tasks;
                                  });
                                }),
                          ],
                          child: ListTile(
                            title: Text(
                              '${tasks[index].task}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: tasks[index].isSelect
                                      ? Colors.black54
                                      : AppColors.TextColour,
                                  fontWeight: FontWeight.w600,
                                  decoration: tasks[index].isSelect
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontStyle: tasks[index].isSelect
                                      ? FontStyle.italic
                                      : FontStyle.normal),
                            ),
                            trailing: CircularCheckBox(
                                value: tasks[index].isSelect,
                                checkColor: Colors.white,
                                activeColor: AppColors.appTheme,
                                inactiveColor: Colors.white,
                                onChanged: (val) => this.setState(() {
                                      tasks[index].isSelect =
                                          !tasks[index].isSelect;
                                    })),
                            onTap: () {
                              this.setState(() {
                                tasks[index].isSelect = !tasks[index].isSelect;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
