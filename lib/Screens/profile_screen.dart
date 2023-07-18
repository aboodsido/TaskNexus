import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Widgets/drawer_widget.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/contact_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  // ignore: use_key_in_widget_constructors
  const ProfileScreen({required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String phoneNumber = '';
  String email = '';
  String name = '';
  String? imageUrl;
  String job = '';
  String joinedAt = '';
  bool isSameUser = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    isLoading = true;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId!)
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          job = userDoc.get('companyPosition');
          imageUrl = userDoc.get('imageUrl');
          name = userDoc.get('fullName');
          Timestamp joinedAtTimestamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimestamp.toDate();
          String formattedDate = DateFormat('d MMMM yyyy').format(joinedDate);
          joinedAt = formattedDate;
        });
        User? user = _auth.currentUser;
        String uid = user!.uid;
        //todo: check if same user
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void launchWhatsApp({required String phone}) async {
      Uri url = Uri.parse("whatsapp://send?phone=$phone");
      try {
        await launchUrl(url);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Whatsapp is not installed"),
          backgroundColor: Colors.red,
        ));
      }
    }

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

    void launchCallNumber({
      required String phoneNumber,
    }) async {
      Uri url = Uri.parse("tel:$phoneNumber");
      try {
        await launchUrl(url);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Could not call this number"),
          backgroundColor: Colors.red,
        ));
      }
    }

    Color scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      drawer: DrawerWidget(),
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: scaffoldColor,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Card(
          margin: const EdgeInsets.all(30),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(imageUrl == null
                          ? 'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png'
                          : imageUrl!),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            job,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Joined At: $joinedAt',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(thickness: 2),
                const SizedBox(height: 10),
                const Text(
                  'Contact Info',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ContactDetail(
                  icon: Icons.mail,
                  label: 'Email:',
                  value: email,
                ),
                const SizedBox(height: 10),
                ContactDetail(
                  icon: Icons.phone,
                  label: 'Phone:',
                  value: phoneNumber,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: IconButton(
                        icon: const Icon(Icons.call),
                        color: Colors.white,
                        onPressed: () {
                          //todo: Perform call action
                          launchCallNumber(phoneNumber: phoneNumber);
                        },
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: const Icon(Icons.mail),
                        color: Colors.white,
                        onPressed: () {
                          //todo: Perform email action
                          launchEmail(
                              email: email,
                              subject: 'hello',
                              body: 'this is pre-filled message');
                        },
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.whatsapp),
                        color: Colors.white,
                        onPressed: () {
                          //todo: Perform WhatsApp action
                          launchWhatsApp(phone: phoneNumber);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
