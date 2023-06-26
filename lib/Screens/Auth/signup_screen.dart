import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks_management/Widgets/submit_button_widget.dart';

import '../../Widgets/cached_network_image.dart';
import '../../Constants/consts.dart';
import '../../Widgets/select_image_widget.dart';
import '../../Widgets/text_form_field_widget.dart';
import '../../Widgets/title_textfield_widget.dart';

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
  final TextEditingController _companyTextController =
      TextEditingController(text: 'Company Position');
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
    _companyTextController.dispose();
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
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      //* this is when the user click anywhere outside the text fields , it will unfocus the field :)
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                        const TitleTextField(title: "Full Name"),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: TextFormFieldWidget(
                                  currentFocusNode: _fullNameFocusNode,
                                  enabled: true,
                                  hintText: 'Jack Mickel',
                                  prefixIcon: Icons.person,
                                  textInputType: TextInputType.name,
                                  fieldTextController: _fullNameTextController,
                                  requestFocusNode: _emailFocusNode,
                                  validatorFunc: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains(' ')) {
                                      return "You should enter a valid Full Name";
                                    }
                                    return null;
                                  },
                                )),
                            Expanded(
                              flex: 1,
                              child: SelectImageWidget(imageFile: imageFile),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const TitleTextField(title: "Email"),
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
                        const TitleTextField(title: "Password"),
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
                        const TitleTextField(title: 'Phone Number'),
                        const SizedBox(height: 8),
                        TextFormFieldWidget(
                          enabled: true,
                          currentFocusNode: _phoneNumFocusNode,
                          requestFocusNode: _companyFocusNode,
                          prefixIcon: Icons.phone,
                          textInputType: TextInputType.phone,
                          hintText: '+970 56 -------',
                          fieldTextController: _phoneNumTextController,
                          validatorFunc: (value) {
                            if (value!.isEmpty) {
                              return "You should enter a valid Phone Number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const TitleTextField(title: "Company Position"),
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            showCategoryDialog(size);
                          },
                          child: TextFormFieldWidget(
                            currentFocusNode: _companyFocusNode,
                            enabled: false,
                            hintText: '',
                            prefixIcon: Icons.account_tree_outlined,
                            textInputType: TextInputType.none,
                            fieldTextController: _companyTextController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 42),
                  SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: SubmitButtonWidget(
                        buttonText: 'Sign up',
                        submitFunc: submitFormOnSignUp,
                      )),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  Future<dynamic> showCategoryDialog(Size size) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentTextStyle: GoogleFonts.montserrat(
              color: Colors.indigo.shade900,
              fontStyle: FontStyle.italic,
              fontSize: 15),
          title: Row(
            children: [
              Text(
                'Jobs',
                style: GoogleFonts.montserrat(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade300,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.pink,
              )
            ],
          ),
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: size.width * 0.6,
                  height: size.height * 0.4,
                  child: ListView.builder(
                    itemCount: jobCategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _companyTextController.text =
                                  jobCategories[index];
                            });
                            Navigator.canPop(context)
                                ? Navigator.pop(context)
                                : null;
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.work_outline,
                                color: Colors.pink.shade300,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                jobCategories[index],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
