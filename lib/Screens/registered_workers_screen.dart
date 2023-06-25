import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/drawer_widget.dart';

import '../Widgets/card_widget.dart';

class RegisteredWorkersScreen extends StatefulWidget {
  const RegisteredWorkersScreen({super.key});

  @override
  State<RegisteredWorkersScreen> createState() =>
      _RegisteredWorkersScreenState();
}

class _RegisteredWorkersScreenState extends State<RegisteredWorkersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Registered Workers',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (ctx, index) => CardWidget(
          cardOnTap: () {},
          iconOnTap: () {},
          cardTitle: 'Test Title',
          cardSubTitle: 'Test Subtitle',
          cardTailIcon: Icons.mail,
          imageUrl: 'assets/images/done.jpg',
        ),
        itemCount: 10,
      ),
    );
  }
}
