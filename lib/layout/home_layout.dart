// ignore_for_file: use_key_in_widget_constructors, avoid_print, must_be_immutable
// ignore_for_file: prefer_const_literals_to_create_immutables ,prefer_const_constructors
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  // * @@@@@@@@@@@@@@@@@@@@@@ Start of variables @@@@@@@@@@@@@@@@@@@@@@
  int currentIndex = 0;
  List<Widget> screen = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var statusController = TextEditingController();

  bool isBottomSheetShown = false;

  @override
  void initState() {
    super.initState();
    creatDatabase();
  }
  // * @@@@@@@@@@@@@@@@@@@@@@ End of variables @@@@@@@@@@@@@@@@@@@@@@@@@@

  // ! @@@@@@@@@@@@@@@@@@@@@@ Start of Build @@@@@@@@@@@@@@@@@@@@@@@@@@
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
      ),
      body: ConditionalBuilder(
        condition: tasks.length > 0,
        builder: (context) => screen[currentIndex],
        fallback: (context) => Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formkey.currentState!.validate()) {
              insertToDatabase(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text,
              ).then((value) {
                getDataFromDatabase(database).then((value) {
                  Navigator.pop(context);

                  setState(() {
                    isBottomSheetShown = false;
                    fabicon = Icons.edit;
                    tasks = value;
                  });
                });
              });
            }
          } else {
            scaffoldKey.currentState!
                .showBottomSheet(
                  (context) => Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // * Title
                          defaultFormField(
                            controller: titleController,
                            type: TextInputType.text,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Title ';
                              }
                              return null;
                            },
                            label: 'Taks Title',
                            prefix: Icons.title,
                          ),
                          SizedBox(height: 15.0),
                          // * Time
                          defaultFormField(
                            controller: timeController,
                            type: TextInputType.datetime,
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timeController.text =
                                    value!.format(context).toString();
                                print(value.format(context));
                              });
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Pleas Enter Time';
                              }
                              return null;
                            },
                            label: 'Task Time',
                            prefix: Icons.watch_later_outlined,
                          ),

                          SizedBox(height: 15.0),
                          defaultFormField(
                            controller: dateController,
                            type: TextInputType.datetime,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2023-03-15'),
                              ).then((value) {
                                dateController.text =
                                    DateFormat.yMd().format(value!);
                              });
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Pleas Enter Date';
                              }
                              return null;
                            },
                            label: 'Task Date',
                            prefix: Icons.calendar_today,
                          ),

                          SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                  ),
                  elevation: 20.0,
                )
                .closed
                .then((value) {
              isBottomSheetShown = false;
              setState(() {
                fabicon = Icons.edit;
              });
            });

            isBottomSheetShown = true;
            setState(() {
              fabicon = Icons.add;
            });
          }
        },
        child: Icon(fabicon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
              ),
              label: " Task"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check,
              ),
              label: "Done"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.archive_outlined,
              ),
              label: "Archived"),
        ],
      ),
    );
  }
  // ! @@@@@@@@@@@@@@@@@@@@@@ End of Build @@@@@@@@@@@@@@@@@@@@@@@@@@

  // ? @@@@@@@@@@@@@@@@@@@@@@ Start of Function @@@@@@@@@@@@@@@@@@@@@@

  void creatDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('db created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT,time TEXT,status TEXT)')
            .then(
          (value) {
            print('table Created');
          },
        ).catchError(
          (error) {
            print('Error when creating table: ${error.toString()} ');
          },
        );
      },
      onOpen: (database) {
        getDataFromDatabase(database).then((value) {
          setState(() {
            tasks = value;
          });
        });
        print('database opened');
      },
    );
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","New")')
          .then((value) {
        print('$value inserted successfully ');
      }).catchError((error) {
        print("Error when inserting new record ${error.toString()}");
      });
    });
  }
}


  // ? @@@@@@@@@@@@@@@@@@@@@@ End of Function @@@@@@@@@@@@@@@@@@@@@@

