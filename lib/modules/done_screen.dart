import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_app/shared/component/componet.dart';
import 'package:udemy_app/shared/cubit/cubit.dart';
import 'package:udemy_app/shared/cubit/states.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var dataTasks = AppCubit.get(context).doneDataTasks;

          return noTasks(dataTasks: dataTasks);
        },
        listener: (context, state) => {});
  }
}
