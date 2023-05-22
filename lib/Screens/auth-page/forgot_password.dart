import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../Utils/snack_bar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).brightness;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor:
                theme == Brightness.dark ? screenDarkColor : screenColor,
            title: const Text('Forgot Password'),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: size.height * 0.4,
              margin: EdgeInsets.only(top: size.height * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Form(
                    key: _globalKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ThemeData().colorScheme.copyWith(
                                primary: primaryColor,
                              ),
                        ),
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Input you E-mail';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Invalid email';
                            } 
                          },
                          onSaved: (newValue) {
                            emailController.text = newValue!;
                          },
                          cursorColor: primaryColor.withOpacity(0.7),
                          controller: emailController,
                          obscureText: false,
                          maxLines: 1,
                          decoration: userFieldDecoration(
                            icon: const Icon(Icons.mail_rounded),
                            labelText: 'E-mail',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  SizedBox(
                    height: size.height * 0.065,
                    width: size.width * 0.7,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          primaryColor,
                        ),
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (!_globalKey.currentState!.validate()) {
                          return;
                        } else {
                          _globalKey.currentState!.save();
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(
                                    email: emailController.text.trim())
                                .then((value) {
                              final SnackBar showSnackBar = snackBar(context, 
                                  'Your reset mail has been sent to email provided',
                                  1,
                                  size.width * 0.8,
                                  primaryColor.withOpacity(0.3));
                              ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                                  ..showSnackBar(showSnackBar);
                            });
                          } on SocketException catch (e) {
                            final SnackBar showSnackBar = snackBar(context, 
                                'No internet connection - $e',
                                1,
                                size.width * 0.8,
                                primaryColor.withOpacity(0.3));
                            ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                                ..showSnackBar(showSnackBar);
                          } catch (e) {
                            final SnackBar showSnackBar = snackBar(context, 
                                'Something went wrong, check your internet',
                                1,
                                size.width * 0.8,
                                primaryColor.withOpacity(0.3));
                            ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                                ..showSnackBar(showSnackBar);
                          }
                        }
                      },
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration userFieldDecoration(
      {required Widget icon, required String labelText, Widget? suffixIcon}) {
    return InputDecoration(
        // contentPadding: EdgeInsets.only(left: 10, right: 10),
        errorStyle: TextStyle(color: errorColor.withOpacity(0.8)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: errorColor.withOpacity(0.8), width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: errorColor.withOpacity(0.8), width: 1.5)),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: icon,
        ),
        suffixIcon: suffixIcon,
        focusColor: primaryColor,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryColor, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5)),
        labelText: labelText,
        labelStyle: TextStyle(color: primaryColor.withOpacity(0.6)));
  }
}
