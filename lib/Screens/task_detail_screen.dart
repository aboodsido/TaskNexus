import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tasks_management/custom_dialog.dart';

import '../Constants/consts.dart';
import '../Widgets/comment_widget.dart';
import '../Widgets/submit_button_widget.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;
  final String uploadedBy;

  const TaskDetailScreen(
      {super.key, required this.taskId, required this.uploadedBy});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool isLoading = false;
  @override
  void initState() {
    getTaskDetail();
    getUserUploadedTask();
    super.initState();
  }

  var textStyle_1 = TextStyle(
    color: kIndigoColor,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );

  var textStyle_2 = TextStyle(
    color: kIndigoColor,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  int selectedButtonIndex = -1;

  bool isVisible = false;
  TextEditingController commentFieldController = TextEditingController();

  String authorName = '';
  String authorPosition = '';
  String authorImage = '';
  String uploadedOn = '';
  String deadlineDate = '';
  String deadlineDateTimeStamp = '';
  String taskDescription = '';
  String taskTitle = '';
  bool isDone = false;
  bool isDeadlineAvailable = false;
  List<String> taskComments = [];

  void getUserUploadedTask() async {
    try {
      setState(() {
        isLoading = true;
      });
      DocumentSnapshot userkDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uploadedBy)
          .get();

      if (userkDoc == null) {
        return;
      } else {
        setState(() {
          authorName = userkDoc.get('fullName');
          authorPosition = userkDoc.get('companyPosition');
          authorImage = userkDoc.get('imageUrl');
        });
      }
    } catch (e) {
      CustomDialog.showSnackBar(context, e.toString(), Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getTaskDetail() async {
    try {
      setState(() {
        isLoading = true;
      });
      DocumentSnapshot taskDoc = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();
      if (taskDoc == null) {
        return;
      } else {
        setState(() {
          Timestamp joinedAtTimestamp = taskDoc.get('createdAt');
          var uploadedDate = joinedAtTimestamp.toDate();
          String formattedDate = DateFormat('d MMMM yyyy').format(uploadedDate);
          uploadedOn = formattedDate;
          //----------------
          Timestamp deadlineTimestamp = taskDoc.get('deadlineDateTimeStamp');
          var deadlineDate = deadlineTimestamp.toDate();
          String formattedDeadlineDate =
              DateFormat('d MMMM yyyy').format(deadlineDate);
          deadlineDateTimeStamp = formattedDeadlineDate;
          //----------------
          isDeadlineAvailable = deadlineDate.isAfter(DateTime.now());
          taskTitle = taskDoc.get('taskTitle');
          taskDescription = taskDoc.get('taskDescription');
          isDone = taskDoc.get('isDone');
        });
      }
    } catch (e) {
      CustomDialog.showSnackBar(context, e.toString(), Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String uid = user!.uid;

    return ModalProgressHUD(
      blur: 5,
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: Colors.indigo.shade800),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    taskTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kIndigoColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 10,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Uploaded By',
                              style: TextStyle(
                                color: kIndigoColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.pink.shade800,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(authorImage),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      authorName,
                                      style: textStyle_1,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      authorPosition,
                                      style: textStyle_1,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(thickness: 2),
                        const SizedBox(height: 5),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Uploaded on:',
                                  style: textStyle_2,
                                ),
                                Text(
                                    style: TextStyle(
                                      color: kIndigoColor,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    ),
                                    uploadedOn),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Deadline Date:',
                                  style: textStyle_2,
                                ),
                                Text(
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    ),
                                    deadlineDateTimeStamp),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              isDeadlineAvailable
                                  ? 'Still have time'
                                  : 'The Deadline has expired',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDeadlineAvailable
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(thickness: 2),
                        const SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Done State:',
                              style: textStyle_2,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                doneTextButton(
                                  buttonText: 'Done',
                                  iconColor: Colors.green,
                                  onPressed: () {
                                    if (uid == widget.uploadedBy) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(widget.taskId)
                                            .update({'isDone': true});
                                        getTaskDetail();
                                      } catch (e) {
                                        CustomDialog.showSnackBar(
                                            context, e.toString(), Colors.red);
                                      }
                                    } else {
                                      CustomDialog.showSnackBar(
                                          context,
                                          'You Don\'t have access to do this',
                                          Colors.red);
                                    }
                                  },
                                  opacity: isDone == true ? 1 : 0,
                                ),
                                const SizedBox(width: 20),
                                doneTextButton(
                                  buttonText: 'Not Done Yet',
                                  iconColor: Colors.red,
                                  onPressed: () {
                                    if (uid == widget.uploadedBy) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(widget.taskId)
                                            .update({'isDone': false});
                                        getTaskDetail();
                                      } catch (e) {
                                        CustomDialog.showSnackBar(
                                            context, e.toString(), Colors.red);
                                      }
                                    } else {
                                      CustomDialog.showSnackBar(
                                          context,
                                          'You Don\'t have access to do this',
                                          Colors.red);
                                    }
                                  },
                                  opacity: isDone == false ? 1 : 0,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(thickness: 2),
                            const SizedBox(height: 5),
                            Text(
                              'Task Description:',
                              style: textStyle_2,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              taskDescription,
                              style: TextStyle(
                                color: kIndigoColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Visibility(
                              visible: isVisible == false ? true : false,
                              child: Center(
                                child: SubmitButtonWidget(
                                    submitFunc: () {
                                      setState(() {
                                        isVisible = true;
                                      });
                                    },
                                    buttonText: 'Add Comment'),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: isVisible ? 1.0 : 0.0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeIn,
                              child: Visibility(
                                visible: isVisible,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        controller: commentFieldController,
                                        keyboardType: TextInputType.text,
                                        maxLines: 7,
                                        maxLength: 1000,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          SubmitButtonWidget(
                                              submitFunc: () {
                                                //todo: add comment to screen & firebase
                                              },
                                              buttonText: 'Post'),
                                          const SizedBox(height: 5),
                                          SubmitButtonWidget(
                                              submitFunc: () {
                                                setState(() {
                                                  isVisible = false;
                                                });
                                              },
                                              buttonText: 'Cancel'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) => CommentWidget(),
                              separatorBuilder: (ctx, index) => const Divider(),
                              itemCount: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton doneTextButton({
    required VoidCallback onPressed,
    required String buttonText,
    required Color iconColor,
    required double opacity,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Text(
            buttonText,
            style: TextStyle(
              color: kIndigoColor,
              fontStyle: FontStyle.italic,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 5),
          Opacity(
            opacity: opacity,
            child: Icon(
              Icons.check_box,
              color: iconColor,
            ),
          )
        ],
      ),
    );
  }
}
