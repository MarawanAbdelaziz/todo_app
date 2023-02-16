// ignore_for_file: use_key_in_widget_constructors,prefer_const_constructors, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/counter/cubit/cubit.dart';
import 'package:todo_app/modules/counter/cubit/states.dart';

class CounterScreen extends StatelessWidget {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterStates>(
        listener: (context, state) {
          if (state is CounterMinusStates) {
            print('Counter Minus ${state.counter}');
          }
          if (state is CounterPlusStates) {
            print('Counter Plus ${state.counter}');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Counter',
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 270.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        CounterCubit.get(context).minus();
                      },
                      child: Text(
                        'Minus',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0,
                      ),
                      child: Text(
                        '${CounterCubit.get(context).counter}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        CounterCubit.get(context).plus();
                      },
                      child: Text(
                        'Plus',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
