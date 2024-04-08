import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_app/modules/archived_screen.dart';
import 'package:udemy_app/modules/done_screen.dart';
import 'package:udemy_app/modules/tasks_screen.dart';
import 'package:udemy_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitailState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  bool isBtnShow = false;
  IconData fabIcon = Icons.edit;

  List<String> titles = [
    'Tasks Screen',
    'Done Task Screen',
    'Archived Task Screen',
  ];
  List<Widget> screens = [
    TaskScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  void changeCurrent(int index) {
    currentIndex = index;
    emit(AppBottomNavBarState());
  }

  void bottomSheetChange({
    required bool isBottomSheetShow,
    required IconData icon,
  }) {
    isBtnShow = isBottomSheetShow;
    fabIcon = icon;
    emit(AppFabChangeIconState());
  }

  Database? database;
  List<Map> newDataTasks = [];
  List<Map> doneDataTasks = [];
  List<Map> archivedDataTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database creates');
        database
            .execute(
                'CREATE TABLE Test (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('table creates');
        }).catchError((onError) {
          print('not create database the error ..$onError');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opended');
      },
    ).then((value) {
      database = value;
      // print(database);
      emit(AppCreateDatabaseState());
    });
  }

  Future insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO Test(title,date,time,status) VALUES("$title","$date","$time","new task")')
          .then((value) {
        print('inserted Successfuully .. $value');
        emit(AppInsertDatabase());

        getDataFromDatabase(database);
      }).catchError((onError) {
        print("error in insert data $onError");
      });
      return Null;
    });
  }

  void getDataFromDatabase(database) {
    newDataTasks = [];
    doneDataTasks = [];
    archivedDataTasks = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM Test').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new task')
          newDataTasks.add(element);
        else if (element['status'] == 'done')
          doneDataTasks.add(element);
        else
          archivedDataTasks.add(element);
      });

      emit(AppGetDatabaseState());
      print(value);
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) {
    database!.rawUpdate(
      'UPDATE Test SET status =? WHERE id =?',
      ['$status', id],
    ).then((value) {
      // this important
      getDataFromDatabase(
          database); // لعدم وجود هذا السطر كان هنالك خطأ عدم ظهور الداتا في مكانها الصحيح عند التحديث
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDatabase({
    required int id,
  }) {
    database!.rawDelete('DELETE FROM Test WHERE id = ? ',[id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataState());
    });
  }
}
