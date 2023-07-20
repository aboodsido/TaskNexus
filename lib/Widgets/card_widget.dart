import 'package:flutter/material.dart';

import '../Constants/consts.dart';

class CardWidget extends StatelessWidget {
  final String imageUrl;
  final String cardTitle;
  final String cardSubTitle;
  final IconData cardTailIcon;
  final VoidCallback cardOnTap;
  final VoidCallback iconOnTap;
  final VoidCallback? onLongPress;

  const CardWidget(
      {super.key,
      required this.imageUrl,
      required this.cardTitle,
      required this.cardSubTitle,
      required this.cardTailIcon,
      required this.cardOnTap,
      required this.iconOnTap,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: cardOnTap,
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  imageUrl.contains('assets/images')
                      ? Image.asset(
                          imageUrl,
                          width: 40,
                        )
                      : Image.network(
                          imageUrl,
                          width: 40,
                        ),
                  const SizedBox(width: 10),
                  Container(height: 30, width: 1, color: kIndigoColor),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 240,
                        child: Text(
                          cardTitle,
                          style: kTaskTitleFont,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                      Icon(
                        Icons.linear_scale,
                        color: Colors.pink.shade800,
                      ),
                      SizedBox(
                        width: 240,
                        child: Text(
                          cardSubTitle,
                          style: kTaskDiscFont,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: iconOnTap,
                icon: Icon(cardTailIcon),
                color: Colors.pink.shade800,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
