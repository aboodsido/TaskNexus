import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks_management/Screens/task_detail_screen.dart';
import 'package:tasks_management/custom_dialog.dart';

import '../Constants/consts.dart';
import '../Widgets/card_widget.dart';
import '../Widgets/drawer_widget.dart';

class AllTasksScreen extends StatefulWidget {
  String userId;
  String taskId = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uploadedBy = '';

  AllTasksScreen({super.key, required this.userId});
  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  String? taskCategory;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Tasks',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  showCategoryDialog(context, size);
                },
                icon: const Icon(Icons.filter_list)),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .orderBy(descending: true, 'createdAt')
            .where('taskCategory', isEqualTo: taskCategory)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemBuilder: (ctx, index) => CardWidget(
                  onLongPress: () {
                    widget.taskId = snapshot.data!.docs[index].get('taskId');
                    widget.uploadedBy =
                        snapshot.data!.docs[index].get('uploadedBy');
                    buildDeleteDialog(context);
                  },
                  cardOnTap: () {
                    widget.taskId = snapshot.data!.docs[index].get('taskId');
                    widget.uploadedBy =
                        snapshot.data!.docs[index].get('uploadedBy');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(
                            taskId: widget.taskId,
                            uploadedBy: widget.uploadedBy),
                      ),
                    );
                  },
                  iconOnTap: () {},
                  cardTitle: snapshot.data!.docs[index].get('taskTitle'),
                  cardSubTitle:
                      snapshot.data!.docs[index].get('taskDescription'),
                  cardTailIcon: Icons.arrow_forward_ios,
                  imageUrl: snapshot.data!.docs[index].get('isDone') == false
                      ? 'assets/images/inprogress.png'
                      : 'assets/images/done.jpg',
                ),
                itemCount: snapshot.data!.docs.length,
              );
            } else {
              return const Center(
                child: Text('There is no Tasks yet'),
              );
            }
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }

  Future<dynamic> buildDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          content: GestureDetector(
            onTap: () {
              User? user = widget._auth.currentUser;
              String uid = user!.uid;
              if (uid == widget.uploadedBy) {
                FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(widget.taskId)
                    .delete();
                Navigator.pop(context);
                CustomDialog.showSnackBar(
                    context, 'Task Deleted Successfully', Colors.green);
              } else {
                Navigator.pop(context);
                CustomDialog.showSnackBar(
                    context,
                    'You can not delete this task, it\'s not belong to you',
                    Colors.red);
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ),
                Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showCategoryDialog(BuildContext context, Size size) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentTextStyle: GoogleFonts.montserrat(
              color: Colors.indigo.shade900,
              fontStyle: FontStyle.italic,
              fontSize: 15),
          title: Row(
            children: [
              Text(
                'Task Category',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade300,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.pink,
              )
            ],
          ),
          content: SizedBox(
            height: size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: size.width * 0.6,
                  height: size.height * 0.4,
                  child: ListView.builder(
                    itemCount: taskCategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              taskCategory = taskCategories[index];
                            });
                            Navigator.canPop(context)
                                ? Navigator.pop(context)
                                : null;
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.pink.shade300,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                taskCategories[index],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        },
                        child: const Text('Close',
                            style: TextStyle(color: Colors.cyan))),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          taskCategory = null;
                        });
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                      child: const Text('Cancel Filter',
                          style: TextStyle(color: Colors.cyan)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
