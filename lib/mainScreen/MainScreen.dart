import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoooo/component/TaskModel.dart';
import 'package:todoooo/controller/pickimage.dart';
import 'package:todoooo/database_service/database.dart';
import 'package:vibration/vibration.dart';
import '../constants.dart';

class MainScreen extends StatefulWidget {
  static String id = 'main_screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<Todo> taskList = [];
  TextEditingController textController = new TextEditingController();
  ImageController imageController = Get.put(ImageController());
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

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning,';
    }
    if (hour < 17) {
      return 'Afternoon,';
    }
    return 'Evening,';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: GestureDetector(
          onLongPress: () {
            Vibration.vibrate(duration: 30, amplitude: 50);
            imageController.showPicker(onselect: (sel_Image) {
              if (sel_Image != null) {
                this.setState(() {
                  imageController.image = sel_Image;
                });
              }
            });
          },
          child: FloatingActionButton(
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
                              suffix: CircleAvatar(
                                backgroundColor: AppColors.appTheme,
                                child: IconButton(
                                  color: Colors.white,
                                  icon: Icon(FontAwesomeIcons.plus),
                                  onPressed: () {
                                    Vibration.vibrate(
                                        duration: 30, amplitude: 50);
                                    if (newTaskTitle != null) {
                                      _addToDb();
                                      textController.clear();
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
                                    Get.back();
                                  },
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'Enter Your Task',
                              hintStyle: TextStyle(color: Colors.white60)),
                          onChanged: (newText) {
                            newTaskTitle = newText;
                          }),
                    ],
                  ),
                ),
              );
            },
            child: Icon(FontAwesomeIcons.plus),
            backgroundColor: AppColors.App_COMPLIMENTARY,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        this.setState(() {
                          imageController.image = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageController.image != null
                                    ? FileImage(imageController.image)
                                    : AssetImage("images/bg.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(60))),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Good ", style: designStyle),
                          Text(greeting(), style: designStyle),
                        ],
                      ),
                    ),
                    Positioned(
                      right: Get.width / 8,
                      bottom: 30,
                      child: Text(
                        taskList.length == 0
                            ? 'Currently No Tasks'
                            : '${taskList.length} Task${taskList.length == 1 ? "" : "s"}',
                        style: GoogleFonts.montserrat(
                            letterSpacing: 2,
                            color: AppColors.TextColour,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                shrinkWrap: true,
                itemCount: taskList.length,
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
