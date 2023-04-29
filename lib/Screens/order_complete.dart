import 'package:farmsies/Constants/images.dart';
import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class OrderComplete extends StatelessWidget {
  const OrderComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            child: Text(
              'Order Completed',
              style: TextStyle(
                fontSize: 27,
                color: primaryColor,
                wordSpacing: 1.5,
              ),
            ),
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.height * 1)
              ),
              child: Image.network(
                orderCompleted,
                scale: 1.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          SizedBox(
            width: size.width * 0.7,
            child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  foregroundColor: MaterialStateProperty.all(textColor),
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done')),
          )
        ]),
      ),
    );
  }
}
