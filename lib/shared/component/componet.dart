import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:udemy_app/shared/cubit/cubit.dart';

Widget buildTaskItem(Map moData, context) => Dismissible(
      key: Key(moData['id'].toString()),
      child: Container(
        padding: EdgeInsetsDirectional.all(10.0),
        margin: EdgeInsetsDirectional.only(start: 9, end: 9, top: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.blueGrey[100],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              child: Text('${moData['time']}'),
            ),
            SizedBox(
              width: 7.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start, // is the better

                // mainAxisAlignment: MainAxisAlignment.start,   =>  not good

                children: [
                  Text(
                    '${moData['title']}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${moData['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 7.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatabase(status: 'done', id: moData['id']);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatabase(status: 'archived', id: moData['id']);
                },
                icon: Icon(Icons.archive, color: Colors.black26)),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: moData['id']);
      },
    );

Widget noTasks({required List dataTasks}) => ConditionalBuilder(
            condition: dataTasks.length > 0,
            builder: (BuildContext context) => ListView.separated(
                itemBuilder: (context, index) =>
                    buildTaskItem(dataTasks[index], context),
                separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsetsDirectional.only(start: 20.0),
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        height: 2.0,
                      ),
                    ),
                itemCount: dataTasks.length),
            fallback: (BuildContext context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu,size: 100.0,color: Colors.grey,),
                  Text("you Don't have Any Task ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          );

