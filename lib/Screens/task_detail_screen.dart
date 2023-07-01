import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/comment_widget.dart';
import '../Widgets/submit_button_widget.dart';

import '../Constants/consts.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
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

  void selectButton(int index) {
    setState(() {
      selectedButtonIndex = index;
    });
  }

  bool isVisible = false;
  TextEditingController commentFieldController = TextEditingController();

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "\"Develop an App\"",
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
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                        'https://thumbs.dreamstime.com/b/close-up-photo-amazing-beautiful-gladly-modern-her-lady-long-wave-wealth-hair-toothy-beaming-smile-wearing-casual-white-t-144265512.jpg'),
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
                                    "Maria Jad",
                                    style: textStyle_1,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Web Developer",
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
                                  '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'),
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
                                  '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Still have time',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
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
                                onPressed: () => selectButton(0),
                                selectedButton: 0,
                              ),
                              const SizedBox(width: 20),
                              doneTextButton(
                                buttonText: 'Not Done Yet',
                                iconColor: Colors.red,
                                onPressed: () => selectButton(1),
                                selectedButton: 1,
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
                            "Lorem Ipsum is simpt ware like Aldus PageMaker including versions of Lorem Ipsum.",
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
    );
  }

  TextButton doneTextButton(
      {required VoidCallback onPressed,
      required String buttonText,
      required int selectedButton,
      required Color iconColor}) {
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
          if (selectedButtonIndex == selectedButton)
            Icon(
              Icons.check_box,
              color: iconColor,
            )
        ],
      ),
    );
  }
}
