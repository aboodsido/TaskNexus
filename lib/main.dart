import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tasks_management/utils/user_state.dart';

import 'Screens/Auth/login_screen.dart';
import 'Screens/Auth/reset_pass_screen.dart';
import 'Screens/Auth/signup_screen.dart';
import 'Screens/add_task_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskNexus',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEDE7DC),
        primarySwatch: Colors.pink,
      ),
      routes: {
        'LoginScreen': (context) => const LoginScreen(),
        'SignUpScreen': (context) => SignUpScreen(),
        'ForgetPassScreen': (context) => ResetPassScreen(),
        'AddTaskScreen': (context) => const AddTaskScreen(),
      },
      home: const UserState(),
    );
  }
}
