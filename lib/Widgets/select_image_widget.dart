import 'dart:io';

import 'package:flutter/material.dart';

class SelectImageWidget extends StatelessWidget {
  const SelectImageWidget({
    super.key,
    required this.imageFile,
  });

  final File? imageFile; 

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21.5),
            border: Border.all(width: 2, color: Colors.white),
          ),
          margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: imageFile == null
                ? Image.network(
                    fit: BoxFit.fill,
                    'https://t4.ftcdn.net/jpg/00/84/67/19/360_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg',
                  )
                : Image.file(imageFile!),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Colors.amber,
                border: Border.all(
                  width: 2,
                  color: Colors.white,
                ),
                shape: BoxShape.circle),
            child: imageFile == null
                ? const Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    size: 20,
                  )
                : const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
          ),
        )
      ],
    );
  }
}
