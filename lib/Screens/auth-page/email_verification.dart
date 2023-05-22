import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../Constants/colors.dart';
import '../../Utils/snack_bar.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool _buttonPaused = false;

  TextEditingController emailVerificationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness;
    final user = FirebaseAuth.instance;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Email Verification'),
          ),
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: const Duration(seconds: 2),
                  child: ElevatedButton(
                    style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  foregroundColor: MaterialStateProperty.all(theme == Brightness.dark ? textDarkColor : textColor),
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                      onPressed: _buttonPaused == true
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                _buttonPaused = true;
                              });
                              await user.currentUser!
                                  .sendEmailVerification()
                                  .then((value) {
                                final SnackBar showSnackBar = snackBar(
                                    context,
                                    'A new mail has been sent, check your mail for verification mail please. You will be able to send a new one in less than a minute.',
                                    5);
                                ScaffoldMessenger.of(context)..removeCurrentSnackBar()
                                    ..showSnackBar(showSnackBar);
                              });
                              Future.delayed(
                                const Duration(seconds: 20),
                                () {
                                  setState(() {
                                    _buttonPaused = false;
                                  });
                                },
                              );
                            },
                      child: _buttonPaused == true
                          ? JumpingText('Waiting')
                          : const Text('Verify your email')),
                ),
                Visibility(
                  visible: _buttonPaused == true ? false : true,
                  child: TextButton(
                      onPressed: () {
                        user.signOut();
                        Navigator.popAndPushNamed(context, '/loginScreen');
                      },
                      child: const Text('Head back to login')),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
