import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Constants/images.dart';
import 'package:farmsies/Widgets/textfields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  // final TextEditingController usernameController = TextEditingController();

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
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: textField(
                  controller: emailController,
                  helperText: 'Email',
                  icon: Icon(Icons.mail_outline_rounded),
                )),
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: textField(
                    controller: usernameController,
                    helperText: 'Username',
                    icon: Icon(Icons.person))),
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: textField(
                    controller: passwordContoller,
                    helperText: 'Password',
                    hideText: true,
                    icon: Icon(
                      Icons.password_rounded,
                    ))),
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: textField(
                    controller: confirmPasswordController,
                    helperText: 'Confirm password',
                    hideText: true,
                    icon: Icon(Icons.password_rounded))),
            SizedBox(
              height: size.height * 0.05,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordContoller.text,
                    
                  );
                  Navigator.popAndPushNamed(context, '/loginScreen');
                } catch (_) {}
                print(emailController.text);
                print(usernameController.text);
                print(passwordContoller.text);
                print(confirmPasswordController.text);
              },
              child: const Text('Sign up'),
            ),
            TextButton(
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(primaryColor.withOpacity(0.3))),
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
        ]
      ),
    );
  }
}
