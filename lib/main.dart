import 'package:flutter/material.dart';
import 'Screens/profile_screen.dart';
import 'Screens/Auth/login_screen.dart';
import 'Screens/Auth/signup_screen.dart';

import 'Screens/Auth/reset_pass_screen.dart';
import 'Screens/add_task_screen.dart';
import 'Screens/all_tasks_screen.dart';
import 'Screens/registered_workers_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tasks Management',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFEDE7DC),
          primarySwatch: Colors.pink,
        ),
        routes: {
          'LoginScreen': (context) => LoginScreen(),
          'SignUpScreen': (context) => SignUpScreen(),
          'ForgetPassScreen': (context) => ResetPassScreen(),
          'AllTasksScreen': (context) => AllTasksScreen(),
          'AddTaskScreen': (context) => AddTaskScreen(),
          'RegisteredWorkersScreen': (context) => RegisteredWorkersScreen(),
          'ProfileScreen': (context) => ProfileScreen(),
        },
        initialRoute: 'AllTasksScreen',
      ),
    );
  }
}
