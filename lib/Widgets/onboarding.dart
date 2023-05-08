// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../Constants/colors.dart';
import '../Constants/images.dart';

class onboardingScreen extends StatelessWidget {
  const onboardingScreen({
    Key? key,
    // required this.code,
    // required this.onboardingText,
    // required this.indicator,
  }) : super(key: key);

  // final String code;
  // final String onboardingText;
  // // final PageController controller;
  // final Widget indicator;
  // final String text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).brightness;
    return IntroductionScreen(
      globalBackgroundColor: theme == Brightness.dark ? primaryDarkColor : primaryColor,
      pages: [
        PageViewModel(
            title: 'Welcome to farmsies',
            body: 'Shop for fresh farm produce directly from your house',
            image:
                SvgPicture.asset(onboarding1, height: size.height * 0.5,),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(color: textDarkColor, fontSize: 25),
              bodyTextStyle: TextStyle(color: textDarkColor, fontSize: 15),
              imageFlex: 3,
                imagePadding: EdgeInsets.all(size.height * 0.05),)),
        PageViewModel(
            title: 'Easy to use',
            body: 'Browse through and place an order',
            image:
                SvgPicture.asset(onboarding2, height: size.height * 0.5),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(color: textDarkColor, fontSize: 25),
              bodyTextStyle: TextStyle(color: textDarkColor, fontSize: 15),
              imageFlex: 3,
              imagePadding: EdgeInsets.all(size.height * 0.05),)),
        PageViewModel(
            title: 'Speedy delivery',
            body: 'Get your items at your door step in no time!',
            image: SvgPicture.asset(onboarding3, height: size.height * 0.5,),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(color: textDarkColor, fontSize: 25),
              bodyTextStyle: TextStyle(color: textDarkColor, fontSize: 15),
              imageFlex: 3,
                imagePadding: EdgeInsets.all(size.height * 0.05),)),
        PageViewModel(
          image: Padding(
            padding: EdgeInsets.only(left: size.width * 0.1, right: size.width * 0.1,),
            child: SvgPicture.asset(drawer, height: size.height * 0.5,),
          ),
          title: 'Get Started',
          body: 'Sign up if you don\'t have an account',
          decoration: PageDecoration(
            titleTextStyle: TextStyle(color: textDarkColor, fontSize: 25),
            bodyTextStyle: TextStyle(color: textDarkColor, fontSize: 15),
            bodyFlex: 1,
            imageFlex: 3
          )
        )
      ],
      initialPage: 0,
      scrollPhysics: const PageScrollPhysics(),
      skipStyle: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(textDarkColor),
        overlayColor: MaterialStateProperty.all(textDarkColor.withOpacity(0.4)),
      ),
      nextStyle: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(textDarkColor),
        overlayColor: MaterialStateProperty.all(textDarkColor.withOpacity(0.4)),
      ),
      doneStyle: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(textDarkColor),
        overlayColor: MaterialStateProperty.all(textDarkColor.withOpacity(0.4)),
      ),
      showSkipButton: true,
      showNextButton: true,
      dotsDecorator: DotsDecorator(
        activeColor: textDarkColor,
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))
      ),
      next: const Text(
        'Next',
      ),
      done: const Text('Done'),
      skip: const Text('Skip'),
      onDone: () => Navigator.popAndPushNamed(context, '/loginScreen'),
      onSkip: () => Navigator.popAndPushNamed(context, '/loginScreen'),
    );
  }
}
