import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks_management/Screens/all_tasks_screen.dart';
import 'package:tasks_management/Screens/profile_screen.dart';
import 'package:tasks_management/Screens/registered_workers_screen.dart';
import 'package:tasks_management/utils/auth.dart';

import '../Constants/consts.dart';
import '../custom_dialog.dart';
import '../utils/user_state.dart';

// ignore: must_be_immutable
class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Color black = Colors.black;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userName = '';
  String? userImage;

  @override
  void initState() {
    getPersonData();
    super.initState();
  }

  void getPersonData() async {
    User? user = _auth.currentUser;
    String uid = user!.uid;

    try {
      DocumentSnapshot userkDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userkDoc != null) {
        setState(() {
          userName = userkDoc.get('fullName');
          userImage = userkDoc.get('imageUrl');
        });
      } else {
        return;
      }
    } catch (e) {
      if (mounted) {
        CustomDialog.showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userId = auth.currentUser!.uid;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName:
                Text(userName, style: GoogleFonts.montserrat(fontSize: 20)),
            accountEmail: Text('Welcome! ', style: textFont),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                userImage == null
                    ? 'https://t4.ftcdn.net/jpg/00/84/67/19/360_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg'
                    : userImage!,
                fit: BoxFit.fill,
              ),
            ),
          ),
          buildListTile(
            icon: Icon(Icons.person_2_outlined, color: black),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(userId: userId)));
            },
            title: 'My Account',
          ),
          buildListTile(
            icon: Icon(Icons.task, color: black),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllTasksScreen(userId: userId)));
            },
            title: 'All Tasks',
          ),
          buildListTile(
            icon: Icon(Icons.people_outline, color: black),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RegisteredWorkersScreen(userId: userId)));
            },
            title: 'Registered Workers',
          ),
          buildListTile(
            icon: Icon(Icons.task_alt_outlined, color: black),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'AddTaskScreen');
            },
            title: 'Add Task',
          ),
          const Divider(),
          buildListTile(
            icon: Icon(Icons.exit_to_app, color: black),
            onTap: () {
              buildLogoutDialog(context);
            },
            title: 'Logout',
          ),
        ],
      ),
    );
  }

  ListTile buildListTile({
    required String title,
    required Icon icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: icon,
      title: Text(title, style: textFont),
      onTap: onTap,
    );
  }
}

Future<dynamic> buildLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.cyan),
            SizedBox(width: 5),
            Text('Sign out')
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.canPop(context) ? Navigator.pop(context) : null;
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.cyan),
            ),
          ),
          TextButton(
            onPressed: () async {
              //todo: logout implementation
              await FirebaseAuthClass().signOut();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const UserState()));
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
        contentPadding: const EdgeInsets.all(20),
        content: const Text('Do you want to sign out ?'),
      );
    },
  );
}
