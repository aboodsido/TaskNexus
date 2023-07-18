import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tasks_management/utils/add_user.dart';
import '../../utils/auth.dart';
import '../../Widgets/submit_button_widget.dart';

import '../../Widgets/cached_network_image.dart';
import '../../Constants/consts.dart';
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
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _fullNameTextController = TextEditingController();
  final TextEditingController _phoneNumTextController = TextEditingController();
  final TextEditingController _companyTextController =
      TextEditingController(text: 'Company Position');
  final TextEditingController _passwordTextController = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _phoneNumFocusNode = FocusNode();
  final FocusNode _companyFocusNode = FocusNode();

  File? imageFile;

  void showSnackBar(BuildContext context, String text, Color color) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      elevation: 20,
      padding: const EdgeInsets.all(10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool isLoading = false;

  void submitFormOnSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (imageFile == null) {
        showSnackBar(context, 'You must provide an Image', Colors.red);
        return;
      }
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuthClass()
            .signUp(_emailTextController.text, _passwordTextController.text);
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Sign up Done Successfully', Colors.green);

        await AddUser().addUsersData(
            fullName: _fullNameTextController.text,
            email: _emailTextController.text,
            companyPosition: _companyTextController.text,
            phoneNumber: _phoneNumTextController.text,
            imageFile: imageFile!);

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showSnackBar(
              context, 'The password provided is too weak.', Colors.red);
        } else if (e.code == 'email-already-in-use') {
          showSnackBar(context, 'The account already exists for that email.',
              Colors.red);
        }
      } catch (e) {
        showSnackBar(context, '$e', Colors.red);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _fullNameTextController.dispose();
    _companyTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _fullNameFocusNode.dispose();
    _phoneNumFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationFunc();
    super.initState();
  }

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
        imageFile = cImage;
      });
    }
  }

  void animationFunc() {
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                                    fieldTextController:
                                        _fullNameTextController,
                                    requestFocusNode: _emailFocusNode,
                                    validatorFunc: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains(' ')) {
                                        return "You should enter a valid Full Name";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(21.5),
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                        ),
                                        margin: const EdgeInsets.only(
                                            top: 5, left: 5, right: 5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: imageFile == null
                                              ? Image.network(
                                                  fit: BoxFit.fill,
                                                  'https://t4.ftcdn.net/jpg/00/84/67/19/360_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg',
                                                )
                                              : Image.file(imageFile!),
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
                                          child: imageFile == null
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
                                  ),
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
                          submitFunc: () {
                            submitFormOnSignUp();
                          },
                        ),
                      ),
                      const SizedBox(height: 20)
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
