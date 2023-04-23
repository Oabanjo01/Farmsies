import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({
    Key? key,
    required this.size,
    required this.text,
  }) : super(key: key);

  final Size size;
  final String text;

  @override
  Widget build(BuildContext context,) {
    return SliverToBoxAdapter(
      child: Container(
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.07, vertical: size.height* 0.08),
          alignment: Alignment.bottomLeft,
          child: Text(text, style: TextStyle(color: primaryColor, fontSize: 20),),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width * 0.05),
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.8),
                primaryDarkColor.withOpacity(0.3)
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.02),
        height: size.height * 0.3,
        decoration: const BoxDecoration(
          image:  DecorationImage(
            opacity: 0.5,
            alignment: Alignment.centerRight,
            image: AssetImage('assets/farmer (1).png',),
          ),
          color: Colors.transparent,
        ),
        width: double.infinity,
      ),
    );
  }
}
