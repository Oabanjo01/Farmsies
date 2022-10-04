import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profilepage extends StatelessWidget {
  Profilepage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> profileItems = [
      {
        'Title': 'My Account',
        'Subtitle': 'My Account Subtitle',
        'Leading Icon': Icons.person_rounded
      },
      {
        'Title': 'My Account',
        'Subtitle': 'My Account Subtitle',
        'Leading Icon': Icons.person_rounded
      }
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.blue,
          expandedHeight: size.height * 0.25,
          centerTitle: true,
          leading: const CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/Avatars/icons8-circled-user-male-skin-type-6-80.png')),
          title: Text(
            'Account Profile',
            style: TextStyle(color: primaryColor),
          ),
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(),
            title: Text(
              'Account Profile',
              style: TextStyle(color: primaryColor),
            ),
            centerTitle: true,
          ),
        ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          delegate: SliverChildBuilderDelegate(
          ((context, index) {
            return Container();
          }
        ), )),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              title: Text(profileItems[index]['Title'], style: TextStyle(color: primaryColor),),
              subtitle: Text(profileItems[index]['Subtitle']),
            );
          }, childCount: profileItems.length),
        )
      ],
    ));
  }
}
