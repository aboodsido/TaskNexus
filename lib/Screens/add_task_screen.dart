import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks_management/Widgets/drawer_widget.dart';
import 'package:uuid/uuid.dart';

import '../Constants/consts.dart';
import '../Widgets/submit_button_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController _categoryController =
      TextEditingController(text: 'Task Category');
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _dateController =
      TextEditingController(text: 'Task Date');

  final _formKey = GlobalKey<FormState>();

  DateTime? picked;
  Timestamp? _deadlineDateTimeStamp;
  String? selectedTaskCategory;

  FirebaseAuth _auth = FirebaseAuth.instance;

  void showSnackBar(BuildContext context, String text, Color color) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      elevation: 20,
      padding: const EdgeInsets.all(10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _dateController.dispose();
    _descController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void addTask() async {
    User? user = _auth.currentUser;
    String uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (_dateController.text == 'Task Date' ||
          _categoryController.text == 'Task Category') {
        showSnackBar(context, 'Check All Fields are filled', Colors.red);
        return;
      }
      var uuid = const Uuid();
      final taskId = uuid.v4();
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).set({
        'taskId': taskId,
        'uploadedBy': uid,
        'taskTitle': _titleController.text,
        'taskDescription': _descController.text,
        'deadlineDate': _dateController.text,
        'deadlineDateTimeStamp': _deadlineDateTimeStamp,
        'taskCategory': _categoryController.text,
        'taskComments': [],
        'isDone': false,
        'createdAt': Timestamp.now(),
      });
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Task Added Successfully', Colors.green);
      setState(() {
        _categoryController.text = 'Task Category';
        _dateController.text = 'Task Date';
        _descController.text = '';
        _titleController.text = '';
      });
    } else {
      print("not done");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: DrawerWidget(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.only(bottom: 30),
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "All Fields are required",
                      style: GoogleFonts.montserrat(
                          fontSize: 22,
                          color: Colors.indigo[900],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text('Task Category*'),
                          const SizedBox(height: 5),
                          textFormField(
                            valueKey: 'TaskCategory',
                            controller: _categoryController,
                            enabled: false,
                            func: () {
                              showCategoryDialog(size);
                            },
                            maxLenght: 100,
                            maxLines: 1,
                          ),
                          text('Task Title*'),
                          const SizedBox(height: 5),
                          textFormField(
                            valueKey: 'TaskTitle',
                            controller: _titleController,
                            enabled: true,
                            func: () {},
                            maxLenght: 100,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          text('Task Description*'),
                          const SizedBox(height: 5),
                          textFormField(
                            valueKey: 'TaskDescription',
                            controller: _descController,
                            enabled: true,
                            func: () {},
                            maxLenght: 1000,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 5),
                          text('Deadline Date*'),
                          const SizedBox(height: 5),
                          textFormField(
                            valueKey: 'DeadlineDate',
                            controller: _dateController,
                            enabled: false,
                            func: () {
                              datePicker();
                            },
                            maxLenght: 100,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: SubmitButtonWidget(
                                buttonText: 'Add task', submitFunc: addTask),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void datePicker() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text =
          '${picked!.year} - ${picked!.month} - ${picked!.day}';
      _deadlineDateTimeStamp =
          Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch);
    } else {
      _dateController.text = _dateController.text;
    }
  }

  Text text(String? text) {
    return Text(
      text!,
      style: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.pink[800],
      ),
    );
  }

  Widget textFormField({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required VoidCallback func,
    required int maxLenght,
    required int maxLines,
  }) {
    return InkWell(
      onTap: func,
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        key: ValueKey(valueKey),
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "You should fill the text field";
          }
          return null;
        },
        maxLength: maxLenght,
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(
            borderSide: BorderSide(width: 0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0, color: Colors.red),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCategoryDialog(Size size) {
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
                'Choose the task category',
                style: GoogleFonts.montserrat(
                  fontSize: 17,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: size.width * 0.6,
                  height: size.height * 0.4,
                  child: ListView.builder(
                    itemCount: taskCategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _categoryController.text = taskCategories[index];
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
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
