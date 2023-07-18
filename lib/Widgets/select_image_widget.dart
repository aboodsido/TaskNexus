import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../Constants/consts.dart';

class SelectImageWidget extends StatefulWidget {
  File? imageFile;

  SelectImageWidget({
    super.key,
    required this.imageFile,
  });

  @override
  State<SelectImageWidget> createState() => _SelectImageWidgetState();
}

class _SelectImageWidgetState extends State<SelectImageWidget> {
  void pickImageWithCamera() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera, maxWidth: 1080, maxHeight: 1080);
      cropImage(pickedFile!.path);
    } on Exception catch (e) {
      print(e);
    }
  }

  void pickImageFromGallery() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1080);
      cropImage(pickedFile!.path);
    } on Exception catch (e) {
      print(e);
    }
  }

  void cropImage(filePath) async {
    CroppedFile? cropImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (cropImage != null) {
      setState(() {
        File cImage = File(cropImage.path);
        widget.imageFile = cImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void showImageDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Please Choose an option',
            style: textFont,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              rowImage(
                  title: 'Camera',
                  icon: Icons.camera_alt,
                  onTap: () {
                    pickImageWithCamera();
                    Navigator.pop(context);
                    print('done');
                  }),
              const SizedBox(height: 15),
              rowImage(
                  title: 'Gallery',
                  icon: Icons.photo,
                  onTap: () {
                    pickImageFromGallery();
                    Navigator.pop(context);
                    print('done');
                  }),
            ],
          ),
        ),
      );
    }

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
            child: widget.imageFile == null
                ? Image.network(
                    fit: BoxFit.fill,
                    'https://t4.ftcdn.net/jpg/00/84/67/19/360_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg',
                  )
                : Image.file(widget.imageFile!),
          ),
        ),
        InkWell(
          onTap: showImageDialog,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Colors.amber,
                border: Border.all(
                  width: 2,
                  color: Colors.white,
                ),
                shape: BoxShape.circle),
            child: widget.imageFile == null
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

  InkWell rowImage({String? title, VoidCallback? onTap, IconData? icon}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.amber),
          const SizedBox(width: 5),
          Text(
            title!,
            style: GoogleFonts.montserrat(
                color: Colors.amber, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
