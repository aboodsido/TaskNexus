import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks_management/Screens/profile_screen.dart';
import 'package:tasks_management/utils/auth.dart';

import '../Constants/consts.dart';
import '../utils/user_state.dart';

// ignore: must_be_immutable
class DrawerWidget extends StatelessWidget {
  DrawerWidget({
    super.key,
  });

  Color black = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Tasks Management',
                style: GoogleFonts.montserrat(fontSize: 20)),
            accountEmail: Text('Welcome!', style: textFont),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/images/appicon.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          buildListTile(
            icon: Icon(Icons.task, color: black),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'AllTasksScreen');
            },
            title: 'All Tasks',
          ),
          buildListTile(
            icon: Icon(Icons.settings_outlined, color: black),
            onTap: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              String userId = auth.currentUser!.uid;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(userId: userId)));
            },
            title: 'My Account',
          ),
          buildListTile(
            icon: Icon(Icons.people_outline, color: black),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, 'RegisteredWorkersScreen');
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
