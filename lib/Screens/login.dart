import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Widgets/textfields.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  TextEditingController userController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            child: Center(
              child: Text(
                'Login',
                style: TextStyle(fontSize: 30, color: primaryColor),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: textField(
                    icon: Icon(Icons.mail),
                    controller: userController,
                    helperText: 'Email',
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: textField(
                    icon: Icon(Icons.password_rounded),
                    hideText: true,
                    controller: passwordController,
                    helperText: 'Password',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor)),
            onPressed: () {
              print(userController.text);
              print(passwordController.text);
            },
            child: Text('Login'),
          ),
          SizedBox(
            height: size.height * 0.005,
          ),
          TextButton(
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(primaryColor.withOpacity(0.3))),
            onPressed: () {
              Navigator.pushNamed(context, '/signupScreen');
            },
            child: Text(
              'Sign up instead?',
              style: TextStyle(color: primaryColor),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(
            width: size.width * 0.1,
            child: Image.asset('assets/google.png'),
          ),
        ],
      ),
    );
  }
}
