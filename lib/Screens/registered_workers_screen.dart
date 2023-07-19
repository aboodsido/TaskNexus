import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks_management/Screens/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/drawer_widget.dart';

import '../Widgets/card_widget.dart';

class RegisteredWorkersScreen extends StatefulWidget {
  String userId;

  RegisteredWorkersScreen({required this.userId});

  @override
  State<RegisteredWorkersScreen> createState() =>
      _RegisteredWorkersScreenState();
}

class _RegisteredWorkersScreenState extends State<RegisteredWorkersScreen> {
  void launchEmail(
      {required String email,
      required String subject,
      required String body}) async {
    String encodedSubject = Uri.encodeComponent(subject);
    String encodedBody = Uri.encodeComponent(body);
    Uri url =
        Uri.parse("mailto:$email?subject=$encodedSubject&body=$encodedBody");
    try {
      await launchUrl(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Could not send email for some issues"),
        backgroundColor: Colors.red,
      ));
    }
  }

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
      body: StreamBuilder<QuerySnapshot>(
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
                  cardOnTap: () {
                    widget.userId = snapshot.data!.docs[index].get('id');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userId: widget.userId)));
                  },
                  iconOnTap: () {
                    launchEmail(
                      email: snapshot.data!.docs[index].get('email'),
                      subject: '',
                      body: '',
                    );
                  },
                  cardTitle: snapshot.data!.docs[index].get('fullName'),
                  cardSubTitle:
                      snapshot.data!.docs[index].get('companyPosition'),
                  cardTailIcon: Icons.mail,
                  imageUrl: snapshot.data!.docs[index].get('imageUrl'),
                ),
                itemCount: snapshot.data!.docs.length,
              );
            }else {
                return const Center(
                  child: Text('There is no Registered Workers yet'),
                );
              }
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
      ),
    );
  }
}
