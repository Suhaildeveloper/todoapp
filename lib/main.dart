import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:udemy_app/layout/home_screen.dart';
import 'package:udemy_app/shared/cubit_observal.dart';

void main() {
    Bloc.observer = MyBlocObserver();
    runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: HomeLayout(),
     debugShowCheckedModeBanner: false,
    );
  }
}
