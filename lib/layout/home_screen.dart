// import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_app/modules/archived_screen.dart';
import 'package:udemy_app/modules/done_screen.dart';
import 'package:udemy_app/modules/tasks_screen.dart';
import 'package:udemy_app/shared/component/constants.dart';
import 'package:udemy_app/shared/cubit/cubit.dart';
import 'package:udemy_app/shared/cubit/states.dart';
import 'package:udemy_app/shared/languge/app_localizations.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabase) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(  // tr.(context) # For translate text Title Screen
              title: Text(cubit.titles[cubit.currentIndex].tr(context)),
            ),
            body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator())),
            //cubit.newDataTasks.isEmpty

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBtnShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    cubit.bottomSheetChange(
                        isBottomSheetShow: false, icon: Icons.add);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20.0),
                          color: Colors.grey[200],
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      label: Text("text_one".tr(context)),
                                      prefixIcon: Icon(Icons.title_rounded),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "warning_title".tr(context);
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {},
                                    controller: titleController,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                      label: Text("task_date".tr(context)),
                                      prefixIcon:
                                          Icon(Icons.date_range_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "warning_date".tr(context);
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2099-01-01'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.MMMMd().format(value!);
                                      });
                                    },
                                    controller: dateController,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                      label: Text("task_time".tr(context)),
                                      prefixIcon: Icon(Icons.watch_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "warning_time".tr(context);
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    controller: timeController,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.bottomSheetChange(
                        isBottomSheetShow: false, icon: Icons.add);
                  });
                  cubit.bottomSheetChange(
                      isBottomSheetShow: true, icon: Icons.edit);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 16.0,
              unselectedFontSize: 15.0,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeCurrent(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'tasks_bottom'.tr(context),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'done_tasks_bottom'.tr(context)
                    ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'archive_tasks_bottom'.tr(context)
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
