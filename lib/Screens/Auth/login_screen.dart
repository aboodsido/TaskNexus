import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tasks_management/utils/auth.dart';

import '../../Constants/consts.dart';
import '../../Widgets/cached_network_image.dart';
import '../../Widgets/submit_button_widget.dart';
import '../../Widgets/text_form_field_widget.dart';
import '../../custom_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _passwordVisible = true;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  bool isLoading = false;

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  void submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuthClass()
            .login(_emailTextController.text, _passwordTextController.text);

        // ignore: use_build_context_synchronously
        CustomDialog.showSnackBar(
            context, 'Login Done Successfully', Colors.green);
        // ignore: use_build_context_synchronously
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          CustomDialog.showSnackBar(
              context, 'No user found for that email.', Colors.red);
        } else if (e.code == 'wrong-password') {
          CustomDialog.showSnackBar(
              context, 'Wrong password provided for that user.', Colors.red);
        }
      } catch (e) {
        CustomDialog.showSnackBar(
            context, 'Something Wrong Happened', Colors.red);
      }
      setState(() {
        isLoading = false;
      });
    }
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
    return GestureDetector(
      //* this is when the user click anywhere outside the text fields , it will unfocus the field :)
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
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
                            TextFormFieldWidget(
                              currentFocusNode: _emailFocusNode,
                              textInputType: TextInputType.emailAddress,
                              prefixIcon: Icons.mail_outline,
                              hintText: 'example@gmail.com',
                              enabled: true,
                              fieldTextController: _emailTextController,
                              requestFocusNode: _passFocusNode,
                              validatorFunc: (value) {
                                if (value!.isEmpty || !value.contains("@")) {
                                  return "You should enter a valid email";
                                }
                                return null;
                              },
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
                            onTap: () => Navigator.of(context)
                                .pushNamed('ForgetPassScreen'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 42),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: SubmitButtonWidget(
                            submitFunc: submitFormOnLogin,
                            buttonText: 'Log in'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
