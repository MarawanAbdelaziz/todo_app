// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
// ignore_for_file:prefer_const_constructors

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  double radius = 0.0,
  required Function function,
  required String text,
  bool isUpperCase = true,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  void Function()? suffixPressed,
  bool isPassword = false,
  bool isClickable = true,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  void Function()? onTap,
  double topRightRadius = 20.0,
  double bottomLeftRadius = 20.0,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(topRightRadius),
          bottomLeft: Radius.circular(bottomLeftRadius),
        )),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
            : null,
      ),
    );

Widget bulidTasksItem(Map model, context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              '${model['time']}',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              )),
          SizedBox(width: 5.0),
          IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archived',
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.archive_outlined,
                color: Colors.red,
              )),
        ],
      ),
    );
