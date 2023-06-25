import 'package:flutter/material.dart';
import 'package:tasks_management/Widgets/drawer_widget.dart';

import '../Widgets/contact_widget.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      // backgroundColor: scaffoldColor,
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
                        },
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: IconButton(
                        icon: const Icon(Icons.message),
                        color: Colors.white,
                        onPressed: () {
                          //todo: Perform WhatsApp action
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
