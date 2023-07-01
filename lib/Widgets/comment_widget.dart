import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CommentWidget extends StatelessWidget {
   CommentWidget({super.key});

   List<Color> colors = [
    Colors.blue.shade700,
    Colors.orange.shade900,
    Colors.brown.shade300,
    Colors.red.shade600,
    Colors.yellow.shade700,
    Colors.purple.shade400,
    Colors.pink.shade700,
  ];


  @override
  Widget build(BuildContext context) {
    colors.shuffle();
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: colors[0],
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://thumbs.dreamstime.com/b/close-up-photo-amazing-beautiful-gladly-modern-her-lady-long-wave-wealth-hair-toothy-beaming-smile-wearing-casual-white-t-144265512.jpg'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'Maria Jad',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50),
            child: Text(
              "This is task is good when it reach the requirments This is task is good when it reach the requirments This is task is good when it reach the requirments",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
