// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks_management/utils/auth.dart';

import '../../Widgets/cached_network_image.dart';
import '../../Widgets/submit_button_widget.dart';
import '../../Widgets/text_form_field_widget.dart';
import '../../Widgets/title_textfield_widget.dart';
import '../../custom_dialog.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  _ResetPassScreenState createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final TextEditingController _emailTextController = TextEditingController();
  final _forgetPassFormKey = GlobalKey<FormState>();

  void submitFormOnForgetPass() async {
    final isValid = _forgetPassFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      try {
        await FirebaseAuthClass().resetPassword(_emailTextController.text);

        // ignore: use_build_context_synchronously
        CustomDialog.showSnackBar(context,
            'Reset Password Complete , Go Check Your Email', Colors.green);
      } catch (e) {
        CustomDialog.showSnackBar(
            context, 'There is an error : $e', Colors.red);
        print(e);
      }
    } else {
      print("not done");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
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
                        const TitleTextField(title: "Email"),
                        const SizedBox(height: 8),
                        TextFormFieldWidget(
                          textInputType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline,
                          hintText: 'example@gmail.com',
                          enabled: true,
                          fieldTextController: _emailTextController,
                          validatorFunc: (value) {
                            if (value!.isEmpty || !value.contains("@")) {
                              return "You should enter a valid email";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 42),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: SubmitButtonWidget(
                        submitFunc: submitFormOnForgetPass,
                        buttonText: "Reset Now"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
