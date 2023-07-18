import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddUser {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addUsersData({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String companyPosition,
    // required String imgUrl,
    required File imageFile,
  }) async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    String? url;

    final Reference ref =
        FirebaseStorage.instance.ref().child('userImages').child('$uid.jpg');
    await ref.putFile(imageFile);
    url = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'id': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'companyPosition': companyPosition,
      'imageUrl': url,
      'createdAt': Timestamp.now()
    });
  }

  Future<void> addImgUrl() async {}
}
