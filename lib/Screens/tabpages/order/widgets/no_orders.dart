import 'package:flutter/material.dart';


class NoOrders extends StatelessWidget {
  const NoOrders({
    Key? key,
    required this.size,
    required this.text
  }) : super(key: key);

  final Size size;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
      ),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: size.height * 0.45,
          child: Center(
            child:
                Text(text),
          ),
        ),
      ),
    );
  }
}
