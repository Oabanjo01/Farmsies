import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../Utils/description_card.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: primaryColor,
          ),
          DescriptionCard(size: size, text: 'Your Order History'),
        ],
      ),
    );
  }
}
