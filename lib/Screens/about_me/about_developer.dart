import 'package:flutter/material.dart';

import '../../../Constants/colors.dart';
import '../../../Utils/description_card.dart';


class AboutDeveloper extends StatelessWidget {
  const AboutDeveloper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: primaryColor,
          ),
          DescriptionCard(size: size, text: 'About me'),
          SliverToBoxAdapter(
            child: Container(
              child: Text('I am Xerxes'),
              alignment: Alignment.center,
              width: size.width * 0.8,
              height: size.height * 0.4,
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            ),
          ),
        ],
      ),
    );
  }
}