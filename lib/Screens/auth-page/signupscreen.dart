import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Constants/images.dart';
import 'package:farmsies/Provider/auth_provider.dart';
import 'package:farmsies/Widgets/generalwidget/errordialogue.dart';
import 'package:farmsies/Widgets/textfields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../Constants/othermethods.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordContoller = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  // final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool showPassword = false;
  bool showPassword1 = false;

  void toggleObscure() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void toggleObscure1() {
    setState(() {
      showPassword1 = !showPassword1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
                padding: EdgeInsets.only(
                  left: size.width * 0.03,
                  right: size.width * 0.03,
                ),
                height: size.height * 0.8,
                child: Opacity(
                    opacity: 0.1,
                    child: SvgPicture.asset(
                      signup,
                      alignment: Alignment.center,
                    ))),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 30, color: primaryColor),
                  ),
                ),
              ),
              spacing(size: size, height: 0.05),
              SizedBox(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(children: [
                      TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Input you e-mail';
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'invalid email';
                          }
                        },
                        onSaved: (newValue) {
                          emailController.text = newValue!;
                        },
                        cursorColor: primaryColor.withOpacity(0.7),
                        controller: emailController,
                        obscureText: false,
                        maxLines: 1,
                        decoration: textFieldDecoration(
                            icon: const Icon(Icons.email), labelText: 'E-mail'),
                      ),
                      spacing(size: size, height: 0.01),
                      TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Input you a username';
                          } else if (value.contains('@')) {
                            // check if usename has a match on firebase already
                            return 'invalid username';
                          }
                        },
                        onSaved: (newValue) {
                          usernameController.text = newValue!;
                        },
                        cursorColor: primaryColor.withOpacity(0.7),
                        controller: usernameController,
                        obscureText: false,
                        maxLines: 1,
                        decoration: textFieldDecoration(
                            icon: const Icon(Icons.person),
                            labelText: 'Username'),
                      ),
                      spacing(size: size, height: 0.01),
                      TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Input you a password';
                          } else if (value.length < 7) {
                            // check if usename has a match on firebase already
                            return 'Passowrd cannot be less than 7';
                          }
                        },
                        onSaved: (newValue) {
                          passwordContoller.text = newValue!;
                        },
                        cursorColor: primaryColor.withOpacity(0.7),
                        controller: passwordContoller,
                        obscureText: showPassword == true ? false : true,
                        maxLines: 1,
                        decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(left: 10, right: 10),
                            errorStyle:
                                TextStyle(color: errorColor.withOpacity(0.8)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: errorColor.withOpacity(0.8),
                                    width: 1.5)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: errorColor.withOpacity(0.8),
                                    width: 1.5)),
                            prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.password_rounded)),
                            suffixIcon: showPassword == true
                                ? IconButton(
                                    onPressed: toggleObscure,
                                    icon: const Icon(Icons.visibility_off))
                                : IconButton(
                                    onPressed: toggleObscure,
                                    icon: const Icon(Icons.visibility_rounded)),
                            focusColor: primaryColor,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: primaryColor, width: 1.5)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: primaryColor.withOpacity(0.5),
                                    width: 1.5)),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: primaryColor.withOpacity(0.6))),
                      ),
                      spacing(size: size, height: 0.01),
                      TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Input your password confirmation detail';
                          } else if (value != passwordContoller.text) {
                            // check if usename has a match on firebase already
                            return 'Must be same as your password';
                          }
                        },
                        onSaved: (newValue) {
                          confirmPasswordController.text = newValue!;
                        },
                        cursorColor: primaryColor.withOpacity(0.7),
                        controller: confirmPasswordController,
                        obscureText: showPassword1 == true ? false : true,
                        maxLines: 1,
                        decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(left: 10, right: 10),
                            errorStyle:
                                TextStyle(color: errorColor.withOpacity(0.8)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: errorColor.withOpacity(0.8),
                                    width: 1.5)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: errorColor.withOpacity(0.8),
                                    width: 1.5)),
                            prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.password_rounded)),
                            suffixIcon: showPassword1 == true
                                ? IconButton(
                                    onPressed: toggleObscure1,
                                    icon: const Icon(Icons.visibility_off))
                                : IconButton(
                                    onPressed: toggleObscure1,
                                    icon: const Icon(Icons.visibility_rounded)),
                            focusColor: primaryColor,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: primaryColor, width: 1.5)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: primaryColor.withOpacity(0.5),
                                    width: 1.5)),
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(
                                color: primaryColor.withOpacity(0.6))),
                      ),
                    ]),
                  ),
                ),
              ),
              spacing(size: size, height: 0.05),
              SizedBox(
                height: size.height * 0.065,
                width: size.width * 0.7,
                child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                      backgroundColor: MaterialStateProperty.all(primaryColor)),
                  onPressed: () async {
                    // await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    //   email: emailController.text,
                    //   password: passwordContoller.text,

                    // );
                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      _formKey.currentState!.save();
                      try {
                        final response = await Provider.of<Authprovider>(
                                context,
                                listen: false)
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordContoller.text);
                        if (response == 'Sign up successful') {
                          Navigator.of(context).pop();
                        } else if (response == 'weak-password') {
                          errorDialogue(context);
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                  },
                  child: const Text('Sign up')
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        primaryColor.withOpacity(0.3))),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/loginScreen');
                },
                child: Text(
                  'Log in instead?',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // InputDecoration passwordfieldDecoration(bool _showPassword, String labelText) {
  //   return InputDecoration(
  //     // contentPadding: EdgeInsets.only(left: 10, right: 10),
  //     errorStyle:
  //         TextStyle(color: errorColor.withOpacity(0.8)),
  //     focusedErrorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(30),
  //         borderSide: BorderSide(
  //             color: errorColor.withOpacity(0.8),
  //             width: 1.5)),
  //     errorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(30),
  //         borderSide: BorderSide(
  //             color: errorColor.withOpacity(0.8),
  //             width: 1.5)),
  //     prefixIcon: const Padding(
  //       padding: EdgeInsets.only(left: 8.0),
  //       child: Icon(Icons.password_rounded)
  //     ),
  //     suffixIcon: _showPassword == true
  //         ? IconButton(onPressed: () {
  //           setState(() {
  //             _showPassword = !_showPassword;
  //           });
  //         }, icon: const Icon(Icons.visibility_off))
  //         : IconButton(onPressed: () {
  //           setState(() {
  //             _showPassword = !_showPassword;
  //           });
  //         }, icon: const Icon(Icons.visibility_rounded)),
  //     focusColor: primaryColor,
  //     focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(30),
  //         borderSide:
  //             BorderSide(color: primaryColor, width: 1.5)),
  //     enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(30),
  //         borderSide: BorderSide(
  //             color: primaryColor.withOpacity(0.5),
  //             width: 1.5)),
  //     labelText: labelText,
  //     labelStyle:
  //         TextStyle(color: primaryColor.withOpacity(0.6)));
  // }

  InputDecoration textFieldDecoration(
      {required Widget icon, required String labelText}) {
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
