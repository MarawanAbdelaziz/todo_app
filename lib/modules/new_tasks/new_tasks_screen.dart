// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
// ignore_for_file:prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) =>
          bulidTasksItem(tasks[index]),
      separatorBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Container(height: 1, color: Colors.grey[350]),
      ),
    );
  }
}
