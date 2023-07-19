import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/Auth/login_screen.dart';
import '../Screens/all_tasks_screen.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.data == null) {
          print('User did not login yet');
          return LoginScreen();
        } else if (userSnapshot.hasData) {
          print('User logged in : ${userSnapshot.data!.email}');
          return AllTasksScreen(
            userId: userSnapshot.data!.uid,
          );
        } else if (userSnapshot.hasError) {
          return const Center(
            child: Text(
              'There is something error',
              style: TextStyle(fontSize: 40),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text(
              'User Not Found',
              style: TextStyle(fontSize: 40),
            ),
          ),
        );
      },
    );
  }
}
