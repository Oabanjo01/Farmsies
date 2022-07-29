import 'package:farmsies/Widgets/onboarding.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _HomeState();
}

class _HomeState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return OnboardingScreen();
  }
}

// 'assets/undraw_online_groceries_a02y.svg'


