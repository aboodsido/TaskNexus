import 'package:flutter/material.dart';
import '../Widgets/drawer_widget.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/contact_widget.dart';

class ProfileScreen extends StatelessWidget {
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/4086/4086679.png'),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Software Engineer',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Joined on: June 1, 2023',
                            style: TextStyle(fontSize: 16),
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
                const ContactDetail(
                  icon: Icons.mail,
                  label: 'Email',
                  value: 'john.doe@example.com',
                ),
                const SizedBox(height: 10),
                const ContactDetail(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: '+1 (555) 123-4567',
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
                          launchCallNumber(phoneNumber: '0568843787');
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
                              email: 'odod41907@gmail.com',
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
                          launchWhatsApp(phone: '+972568843787');
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
