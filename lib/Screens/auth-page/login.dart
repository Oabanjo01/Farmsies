import 'package:farmsies/Constants/othermethods.dart';
import 'package:farmsies/Provider/auth_provider.dart';
import 'package:farmsies/Screens/tabpages/homescreen.dart';
import 'package:farmsies/Widgets/generalwidget/errordialogue.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Widgets/generalwidget/textfields.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../Constants/images.dart';
import '../../Widgets/generalwidget/textbutton.dart';
import 'signupscreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var _isLoading;
     SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent
      )
    );
    return Scaffold(
        body:
            // StreamBuilder(
            //   stream: FirebaseAuth.instance.authStateChanges(),
            //   builder: ((context, snapshot) {
            //     if(snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(child: CircularProgressIndicator(),);
            //     } else if (snapshot.connectionState == ConnectionState.done) {
            //       if (snapshot.hasData) {
            //         return HomeScreen();
            //       } else {
            // return
            Stack(children: [
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
          SizedBox(
            child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          return 'Input your password';
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
                ],
              ),
            ),
          ),
          spacing(size: size, height: 0.05),
          SizedBox(
            height: size.height * 0.065,
            width: size.width * 0.7,
            child: _isLoading == true
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor)),
                    onPressed: () async {
                      if (!_globalKey.currentState!.validate()) {
                        return;
                      } else {
                        _globalKey.currentState!.save();
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          final userCredential = await Provider.of<Authprovider>(context, listen: false)
                            .signInWithEmailAndPassword(
                                email: userController.text,
                                password: passwordController.text);
                          Navigator.of(context,).popAndPushNamed('/homepage', arguments: userCredential!.userMail);
                        } catch (e) {
                          errorDialogue(context, e.toString());
                        }
                      }
                      print(userController.text);
                      print(passwordController.text);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 17),
                    ),
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
              // Provider.of<Authprovider>(context, listen: false)
              //     .signIn()
              //     .then((value) {
              //   Navigator.pop(context, '/homepage');
              // }).catchError((e) {
              //   errorDialogue(context);
              // });
            },
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
    ]));
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
            child: Icon(Icons.password_rounded)),
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
// else {
//   return errorDialogue(context);
// }
// }),
//   )),
// );
