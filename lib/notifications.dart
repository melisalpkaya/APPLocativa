import 'package:flutter/material.dart';
import 'package:locativa/Chunk.dart';

import 'ColorsClass/colors.dart';
import 'Task.dart';

class Notifications extends StatelessWidget {
  Chunk chunk = Chunk.fromChunk();
  List<Task> tasksNew = [];
  Notifications(chunk, {Key? key}) : super(key: key) {
    this.chunk = chunk;
    tasksNew = chunk.getNewTasksNotification;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Bildirimler',
            style: TextStyle(
              color: AppColors.text,
              fontFamily: 'WorkSans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: ListView.separated(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: tasksNew.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListTile(
                leading: Container(
                  height: 50.0,
                  width: 50.0,
                  child: Icon(Icons.notifications_active,
                      size: 30.0, color: AppColors.yellow),
                ),
                title: Text(
                  'Yeni iş !',
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                subtitle: Text(
                  // "TaskID:" +
                  //     chunk.newTasksNotification[index].getTaskID().toString() +
                  //     " " +
                  //     chunk.newTasksNotification[index].type.toString() +
                  //     " " +
                  //     chunk.newTasksNotification[index].status.toString(),
                  chunk.newTasksNotification[index].description.toString(),
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    color: AppColors.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: Text(
                  this
                          .chunk
                          .newTasksNotification[index]
                          .dueDate
                          .day
                          .toString() +
                      "." +
                      this
                          .chunk
                          .newTasksNotification[index]
                          .dueDate
                          .month
                          .toString() +
                      "." +
                      this
                          .chunk
                          .newTasksNotification[index]
                          .dueDate
                          .year
                          .toString(),
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: AppColors.navy,
                  ),
                ),
                onTap: () {},
                enabled: true,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 8);
          },
        ),
      ),
    );
  }
}
