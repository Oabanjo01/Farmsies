import 'package:farmsies/Constants/othermethods.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Widgets/textfields.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Constants/images.dart';
import '../../Widgets/textbutton.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
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
                    login,
                    alignment: Alignment.center,
                  ))),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 30, color: primaryColor),
                ),
              ),
            ),
            spacing(size: size, height: 0.05),
            Container(
              child: Form(
                key: _globalKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Input you username';
                          } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                            return 'invalid email';
                          }
                        },
                        onSaved: (newValue) {
                          userController.text = newValue!;
                        },
                        cursorColor: primaryColor.withOpacity(0.7),
                        controller: userController,
                        obscureText: false,
                        maxLines: 1,
                        decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(left: 10, right: 10),
                            errorStyle: TextStyle(color: errorColor.withOpacity(0.8)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: errorColor.withOpacity(0.8), width: 1.5)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: errorColor.withOpacity(0.8), width: 1.5)),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.mail_rounded),
                            ),
                            focusColor: primaryColor,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: primaryColor, width: 1.5)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5)),
                            labelText: 'E-mail',
                            labelStyle: TextStyle(color: primaryColor.withOpacity(0.6))),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    //   child: textField(
                    //     icon: const Icon(Icons.mail),
                    //     controller: userController,
                    //     helperText: 'Email',
                    //   ),
                    // ),
                    spacing(size: size, height: 0.01),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Input you password';
                          } 
                        },
                        onSaved: (newValue) {
                          passwordController.text = newValue!;
                        },
                        cursorColor: primaryColor.withOpacity(0.7),
                        controller: passwordController,
                        obscureText: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(left: 10, right: 10),
                            errorStyle: TextStyle(color: errorColor.withOpacity(0.8)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: errorColor.withOpacity(0.8), width: 1.5)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: errorColor.withOpacity(0.8), width: 1.5)),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.password_rounded),
                            ),
                            focusColor: primaryColor,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: primaryColor, width: 1.5)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5)),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: primaryColor.withOpacity(0.6))),
                      ),
                    ),
                  ],
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
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)),
                  backgroundColor: MaterialStateProperty.all(primaryColor)),
                  onPressed: () async {
                    if (!_globalKey.currentState!.validate()) {
                      return;
                    } else {
                      _globalKey.currentState!.save();
                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: userController.text,
                            password: passwordController.text,
                          );
                          Navigator.of(context).popAndPushNamed('/homepage');
                        } catch (e) {
                          print(e.toString());
                        }
                      }
                    print(userController.text);
                    print(passwordController.text);
                  },
                child: const Text('Login', style: TextStyle(fontSize: 17),),
              ),
            ),
            spacing(size: size, height: 0.05),
            Textbutton(text: 'Sign up'),
            spacing(size: size, height: 0.1),
            InkWell(
              radius: 30,
              customBorder: const CircleBorder(),
              highlightColor: Colors.transparent,
              splashColor: primaryColor.withOpacity(0.1),
              onTap: () {
                print(userController.text);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.1,
                    child: Image.asset('assets/google.png'),
                  ),
                  spacing(size: size, height: 0.02),
                  Text('Or sign in with Google', style: TextStyle(color: primaryColor),),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

