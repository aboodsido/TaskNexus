import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/cached_network_image.dart';
import '../../Constants/consts.dart';
import '../../Widgets/select_image_widget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _passwordVisible = true;
  TextEditingController? _emailTextController;
  TextEditingController? _fullNameTextController;
  TextEditingController? _phoneNumTextController;
  TextEditingController? _companyTextController;
  TextEditingController? _passwordTextController;

  final _signUpFormKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _phoneNumFocusNode = FocusNode();
  final FocusNode _companyFocusNode = FocusNode();

  File? imageFile;

  void submitFormOnSignUp() {
    final isValid = _signUpFormKey.currentState!.validate();
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
    _passwordTextController?.dispose();
    _fullNameTextController?.dispose();
    _companyTextController?.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _fullNameFocusNode.dispose();
    _phoneNumFocusNode.dispose();
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
            margin: const EdgeInsets.only(top: 100, left: 30, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign Up",
                  style: GoogleFonts.montserrat(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.montserrat(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "Login",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('LoginScreen');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full Name",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: _fullNameFocusNode,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_emailFocusNode),
                              validator: (value) {
                                if (value!.isEmpty || !value.contains(" ")) {
                                  return "You should enter a valid Full Name";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              controller: _fullNameTextController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(width: 0),
                                ),
                                hintText: 'Jack Mickael',
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                filled: true,
                                fillColor: kTextFieldColor,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SelectImageWidget(imageFile: imageFile),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocusNode,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
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
                      const SizedBox(height: 10),
                      Text(
                        "Password",
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _passFocusNode,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_phoneNumFocusNode),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return "You should enter a valid password";
                          }
                          return null;
                        },
                        controller: _passwordTextController,
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _passwordVisible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  _passwordVisible = !_passwordVisible;
                                },
                              );
                            },
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 0),
                          ),
                          hintText: '*************',
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: kTextFieldColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Phone Number",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _phoneNumFocusNode,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_companyFocusNode),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "You should enter a valid Phone Number";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: _phoneNumTextController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 0),
                          ),
                          hintText: '+970 56 --- ----',
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
                      const SizedBox(height: 15),
                      Text(
                        "Company Position",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        focusNode: _companyFocusNode,
                        onEditingComplete: submitFormOnSignUp,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "You should enter a valid Company Position";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: _companyTextController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_tree_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 0),
                          ),
                          hintText: 'Mobile Developer',
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
                Container(
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
                    onPressed: submitFormOnSignUp,
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        )
      ],
    ));
  }
}

