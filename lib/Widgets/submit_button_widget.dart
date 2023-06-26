import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButtonWidget extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const SubmitButtonWidget({
    required this.submitFunc,
    required this.buttonText,
  });

  final VoidCallback submitFunc;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: const MaterialStatePropertyAll(Colors.red),
      ),
      onPressed: submitFunc,
      child: Text(
        buttonText,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
