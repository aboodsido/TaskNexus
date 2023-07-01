import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/consts.dart';
import '../Widgets/drawer_widget.dart';

import '../Widgets/card_widget.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: DrawerWidget(),
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
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (ctx, index) => CardWidget(
          cardTitle: 'Test Title',
          cardSubTitle: 'Test Subtitle',
          imageUrl: 'assets/images/done.jpg',
          cardTailIcon: Icons.arrow_forward_ios,
          iconOnTap: () {},
          cardOnTap: () {
            Navigator.pushNamed(context, "TaskDetailScreen");
          },
        ),
        itemCount: 10,
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
            onTap: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 5),
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                Text(
                  'Delete',
                  style: TextStyle(
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
                      onPressed: () {},
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
