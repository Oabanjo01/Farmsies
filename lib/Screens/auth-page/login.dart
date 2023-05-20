// ignore_for_file: body_might_complete_normally_nullable

import 'package:farmsies/Utils/other_methods.dart';
import 'package:farmsies/Provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:farmsies/Widgets/generalwidget/error_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../Constants/colors.dart';
import '../../Constants/images.dart';
import '../../Utils/snack_bar.dart';
import '../../Widgets/generalwidget/text_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey();
  bool _showPassword = false;

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).brightness;
    // final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    // final User user = firebaseAuth.currentUser!;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
              ),
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: size.height * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 30, color: primaryColor),
                    ),
                  ),
                ),
                spacing(size: size, height: 0.05),
                SizedBox(
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme: ThemeData().colorScheme.copyWith(
                                      primary: primaryColor,
                                    )),
                            child: TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Input you E-mail';
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
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
                              decoration: userFieldDecoration(
                                icon: const Icon(Icons.mail_rounded),
                                labelText: 'E-mail',
                              ),
                            ),
                          ),
                        ),
                        spacing(size: size, height: 0.01),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme: ThemeData()
                                    .colorScheme
                                    .copyWith(primary: primaryColor)),
                            child: TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Input your password';
                                } else if (value.length < 6) {
                                  return 'Password too short';
                                }
                              },
                              onSaved: (newValue) {
                                passwordController.text = newValue!;
                              },
                              cursorColor: primaryColor.withOpacity(0.7),
                              controller: passwordController,
                              obscureText: _showPassword == true ? false : true,
                              maxLines: 1,
                              decoration: passwordfieldDecoration(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  alignment: Alignment.centerRight,
                  width: double.infinity,
                  child: TextButton(
                      child: Text(
                        'Forgot Passowrd',
                        style: TextStyle(color: primaryColor),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgotPassword');
                      }),
                ),
                spacing(size: size, height: 0.03),
                SizedBox(
                  height: size.height * 0.065,
                  width: size.width * 0.7,
                  child: Provider.of<Authprovider>(context).isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                              // setState(() {});
                              try {
                                await Provider.of<Authprovider>(context,
                                        listen: false)
                                    .signInWithEmailAndPassword(
                                        context: context,
                                        email: userController.text,
                                        password: passwordController.text)
                                    .then((User? credential) {
                                  if (!credential!.emailVerified) {
                                    debugPrint('Email not verified');
                                    Navigator.of(context)
                                        .pushNamed('/emailVerification');
                                    final SnackBar showSnackBar = snackBar(
                                        context,
                                        'Check your mail for the verification mail please, or create a new one.',
                                        5);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(showSnackBar);
                                  } else {
                                    debugPrint('Email verified');
                                    Navigator.of(
                                      context,
                                    ).pushNamedAndRemoveUntil(
                                      '/homepage',
                                      (route) => false,
                                    );
                                  }
                                });
                                debugPrint('Did he sign in?');
                                if (mounted) {
                                  setState(() {});
                                }
                                // setState(() {});
                              } catch (e) {
                                String error = Provider.of<Authprovider>(
                                        context,
                                        listen: false)
                                    .errorMessage;
                                errorDialogue(context, error);
                                setState(() {});
                                // !Provider.of<Authprovider>(context, listen: false).isLoading;
                              }
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 17,
                                color: theme == Brightness.dark
                                    ? textDarkColor
                                    : textColor),
                          ),
                        ),
                ),
                spacing(size: size, height: 0.05),
                Textbutton(
                  text: 'Sign up',
                ),
                spacing(size: size, height: 0.1),
                InkWell(
                  radius: 30,
                  customBorder: const CircleBorder(),
                  highlightColor: Colors.transparent,
                  splashColor: primaryColor.withOpacity(0.1),
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.1,
                        child: Image.asset('assets/google.png'),
                      ),
                      spacing(size: size, height: 0.02),
                      Text(
                        'Or sign in with Google',
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ])),
    );
  }

  InputDecoration passwordfieldDecoration() {
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
        prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.password_rounded,
            )),
        suffixIcon: _showPassword == true
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                icon: const Icon(Icons.visibility_off))
            : IconButton(
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                icon: const Icon(Icons.visibility_rounded)),
        focusColor: primaryColor,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryColor, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5)),
        labelText: 'Password',
        labelStyle: TextStyle(color: primaryColor.withOpacity(0.6)));
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
