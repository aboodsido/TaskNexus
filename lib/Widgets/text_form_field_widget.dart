import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/consts.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    this.currentFocusNode,
    this.requestFocusNode,
    this.fieldTextController,
    required this.textInputType,
    required this.prefixIcon,
    required this.hintText,
    this.validatorFunc,
    required this.enabled,
  });

  final FocusNode? currentFocusNode;
  final FocusNode? requestFocusNode;
  final TextEditingController? fieldTextController;
  final TextInputType textInputType;
  final IconData prefixIcon;
  final String hintText;
  final String? Function(String?)? validatorFunc;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      textInputAction: TextInputAction.next,
      focusNode: currentFocusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(requestFocusNode),
      validator: validatorFunc,
      keyboardType: textInputType,
      controller: fieldTextController,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 0),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: kTextFieldColor,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 0, color: Colors.red),
        ),
      ),
    );
  }
}
