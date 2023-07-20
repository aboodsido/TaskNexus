import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasks_management/Screens/profile_screen.dart';

// ignore: must_be_immutable
class CommentWidget extends StatelessWidget {
  String commenterName = '';
  String? commenterImage;
  String commentBody = '';
  Timestamp? commentTimestamp;
  String commentId = '';
  String uploadedBy = '';

  List<Color> colors = [
    Colors.blue.shade700,
    Colors.orange.shade900,
    Colors.brown.shade300,
    Colors.red.shade600,
    Colors.yellow.shade700,
    Colors.purple.shade400,
    Colors.pink.shade700,
  ];

  CommentWidget({
    super.key,
    required this.commenterName,
    required this.commentBody,
    required this.commentTimestamp,
    required this.commenterImage,
    required this.commentId,
    required this.uploadedBy,
  });

  @override
  Widget build(BuildContext context) {
    var uploadedDate = commentTimestamp!.toDate();
    String formattedDate = DateFormat.jm().add_MEd().format(uploadedDate);

    colors.shuffle();
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onLongPress: (){
                  
                },
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userId: uploadedBy),
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: colors[0],
                          ),
                          image: DecorationImage(
                            image: NetworkImage(commenterImage == null
                                ? 'https://t4.ftcdn.net/jpg/00/84/67/19/360_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg'
                                : commenterImage!),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      commenterName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              commentBody,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
