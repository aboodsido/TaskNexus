// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/cached_network_image.dart';
import '../../Constants/consts.dart';

class ResetPassScreen extends StatefulWidget {
  @override
  _ResetPassScreenState createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  TextEditingController? _emailTextController;
  final _forgetPassFormKey = GlobalKey<FormState>();

  void submitFormOnForgetPass() {
    final isValid = _forgetPassFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      print("done");
    } else {
      print("not done");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        CachedNetworkImageWidget(animation: _animation),
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 150, left: 30, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reset Password",
                  style: GoogleFonts.montserrat(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),
                Form(
                  key: _forgetPassFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "You should enter a valid email";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 0),
                          ),
                          hintText: 'example@gmail.com',
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: kTextFieldColor,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(width: 0, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 42),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.red),
                    ),
                    onPressed: submitFormOnForgetPass,
                    child: Text(
                      "Reset Now",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
