import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';

import '../../Constants/colors.dart';


class Headboard extends StatelessWidget {
  const Headboard({
    Key? key,
    required this.size,
    required this.username,
  }) : super(key: key);

  final Size size;
  final String? username;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size.height * 0.1,
        child: Row(children: [
          CircleAvatar(
            child: const Text(
              'picture',
            ),
            radius: size.width * 0.1,
            backgroundColor: primaryColor,
          ),
          SizedBox(
            width: size.width * 0.07,
          ),
          Expanded(
              child: Container(
            alignment: Alignment.centerLeft,
            child: Text('Welcome ${StringUtils.capitalize(username!.toUpperCase())}', style: TextStyle(fontSize: 20),),
          ))
        ]),
      );
  }
}
