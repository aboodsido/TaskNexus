
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color kTextFieldColor = const Color.fromRGBO(240, 240, 240, 0.7);

TextStyle textFont = GoogleFonts.montserrat(fontWeight: FontWeight.w500);

TextStyle kTaskTitleFont = GoogleFonts.montserrat(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.indigo.shade800,
);
TextStyle kTaskDiscFont = GoogleFonts.montserrat(
  fontSize: 15,
  color: Colors.grey,
);

List<String> taskCategories = [
  'Business',
  'Programming',
  'Information Technology',
  'Marketing',
  'Human Resources',
  'Design',
  'Accounting',
];
List<String> jobCategories = [
  'Manager',
  'Team Leader',
  'Desginer',
  'Web Designer',
  'Web Developer',
  'Mobile Developer',
  'Marketing',
  'Digital Marketing',
];

