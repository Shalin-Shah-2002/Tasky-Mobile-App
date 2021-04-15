import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/managers/task_manager.dart';
import 'package:tasky_app/models/task.dart';
import 'package:tasky_app/shared_widgets/custom_appbar_widget.dart';
import 'package:tasky_app/shared_widgets/custom_checkbox_widget.dart';
import 'package:tasky_app/shared_widgets/empty_widget.dart';
import 'package:tasky_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_app/utils/ui_utils/ui_utils.dart';

final TaskManager _taskManager = GetIt.I.get<TaskManager>();

class TaskView extends StatefulWidget {
  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final UiUtilities uiUtilities = UiUtilities();
  String _status;
  // final List<Map<String, dynamic>> data = [
  //   {
  //     'title': 'Provide design team content for next web seminar',
  //     'isCompleted': true,
  //     'date': DateTime.now().subtract(Duration(days: 10)),
  //     'participants': [
  //       "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  //       "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
  //       "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  //       "https://images.unsplash.com/photo-1473700216830-7e08d47f858e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
  //     ]
  //   },
  //   {
  //     'title':
  //         'Create a beautiful physical christmas card for upcoming christmas',
  //     'isCompleted': false,
  //     'date': DateTime.now().subtract(Duration(days: 5)),
  //     'participants': [
  //       "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  //       "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
  //       "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  //       "https://images.unsplash.com/photo-1473700216830-7e08d47f858e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
  //     ]
  //   }
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Tasks',
      ),
      body: StreamBuilder<Task>(
          stream: _taskManager.getTasks().asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return Center(child: CupertinoActivityIndicator());
            }

            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasData) {
              return EmptyWidget(
                imageAsset: 'no_task.png',
                message:
                    'Tasks aasigned to you and tasks created for you appears here.',
              );
            }

            if (snapshot.data == null) {
              return EmptyWidget(
                imageAsset: 'no_task.png',
                message:
                    'Tasks aasigned to you and tasks created for you appears here.',
              );
            }

            return ListView(
              children: [
                Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: Color.fromRGBO(245, 101, 101, 1),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Starred',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    child: Text(
                      'Tasks',
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return TaskListTile(
                          images: snapshot.data.data[index].participants,
                          taskTitle: snapshot.data.data[index].description,
                          isCompleted:
                              snapshot.data.data[index].status == 'completed',
                          onTap: (bool value) {
                            setState(() {
                              snapshot.data.data[index].status =
                                  value ? 'complete' : 'todo';
                            });

                            print(
                                '@@@@@@@@@@@@@@@@@@ ${snapshot.data.data[index]}');
                          },
                          changeStatus: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: StadiumBorder(),
                                    content: SizedBox(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          RadioListTile(
                                              value: 'todo',
                                              groupValue: 'status',
                                              onChanged: (value) {
                                                setState(() {
                                                  _status = value;
                                                });
                                              }),
                                               RadioListTile(
                                              value: 'in progress',
                                              groupValue: 'status',
                                              onChanged: (value) {
                                                setState(() {
                                                  _status = value;
                                                });
                                              }),
                                               RadioListTile(
                                              value: 'completed',
                                              groupValue: 'status',
                                              onChanged: (value) {
                                                setState(() {
                                                  _status = value;
                                                });
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                });

                            // BotToast.showLoading(
                            //     allowClick: false,
                            //     clickClose: false,
                            //     backButtonBehavior: BackButtonBehavior.ignore);
                            // bool isChanged =
                            //     await _taskManager.markTaskAsCompleted(
                            //         status: _status,
                            //         taskId: snapshot.data.data[index].id);
                            // BotToast.closeAllLoading();
                            // if (isChanged) {
                            // } else {
                            //   uiUtilities.actionAlertWidget(
                            //       context: context, alertType: 'error');
                            //   uiUtilities.alertNotification(
                            //       context: context,
                            //       message: _taskManager.message);
                            // }
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              endIndent: 10,
                              indent: 40,
                            ),
                          ),
                      itemCount: snapshot.data.data.length),
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customRedColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () =>
            Navigator.pushReplacementNamed(context, '/createNewTaskView'),
      ),
    );
  }
}

// this widget represent each individual task list tile
class TaskListTile extends StatelessWidget {
  const TaskListTile({
    Key key,
    @required this.images,
    @required this.isCompleted,
    @required this.taskTitle,
    @required this.onTap,
    @required this.changeStatus,
  }) : super(key: key);

  final List<String> images;
  final bool isCompleted;
  final String taskTitle;
  final Function onTap;
  final Function changeStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: CustomCheckBox(
                isChecked: isCompleted,
                onTap: (value) {
                  onTap(value);
                },
                uncheckedColor: customGreyColor,
                checkedColor: Colors.green,
                size: 27,
                checkedWidget: Icon(
                  Icons.check,
                  size: 20,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                '$taskTitle',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: images.length > 2 ? 100.0 : 60),
              child: FlutterImageStack(
                imageList: images,
                extraCountTextStyle: Theme.of(context).textTheme.subtitle2,
                imageBorderColor: Theme.of(context).scaffoldBackgroundColor,
                imageRadius: 25,
                imageCount: images.length,
                imageBorderWidth: 1,
                backgroundColor: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)]
                    .withOpacity(.5),
                totalCount: images.length,
              ),
            ),
            Row(
              children: [
                Text(
                  'Due next week',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: customRedColor),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    showBottomSheet(
                        context: context,
                        elevation: 3,
                        builder: (context) {
                          return Container(
                            height: 220,
                            decoration: BoxDecoration(
                                color: customRedColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius:
                                            BorderRadius.circular(45)),
                                    height: 6,
                                    width: 20,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    changeStatus();
                                  },
                                  title: Text(
                                    'Mark as completed',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.white),
                                  ),
                                  trailing: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: Text(
                                    'Edit Task',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.white),
                                  ),
                                  trailing: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: Text(
                                    'Delete',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.white),
                                  ),
                                  trailing: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: customGreyColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
