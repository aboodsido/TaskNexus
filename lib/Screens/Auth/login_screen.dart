import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/cached_network_image.dart';
import '../../Constants/consts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _passwordVisible = true;
  TextEditingController? _emailTextController;
  TextEditingController? _passwordTextController;
  final _loginFormKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  void submitFormOnLogin() {
    final isValid = _loginFormKey.currentState!.validate();
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
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
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
        // backgroundColor: Colors.blue,
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
                  "Login",
                  style: GoogleFonts.montserrat(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.montserrat(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('SignUpScreen');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Form(
                  key: _loginFormKey,
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
                        textInputAction: TextInputAction.done,
                        focusNode: _passFocusNode,
                        onEditingComplete: submitFormOnLogin,
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
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Text(
                        "FORGOT PASSWORD ?",
                        style: GoogleFonts.montserrat(
                          decoration: TextDecoration.underline,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () =>
                          Navigator.of(context).pushNamed('ForgetPassScreen'),
                    ),
                  ],
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
                    onPressed: submitFormOnLogin,
                    child: Text(
                      "Log in",
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
