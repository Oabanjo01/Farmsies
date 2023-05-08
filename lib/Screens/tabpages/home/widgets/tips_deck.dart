import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Utils/snack_bar.dart';

class Fooddex extends StatefulWidget {
  const Fooddex({
    Key? key,
    required this.size,
    required this.food,
  }) : super(key: key);

  final Size size;
  final List food;

  @override
  State<Fooddex> createState() => _FooddexState();
}

class _FooddexState extends State<Fooddex> {
  Future<void> _lauchTipsUrl(String tipUrl) async {
    final Uri url = Uri.parse(tipUrl);
    if (await canLaunchUrl(url)) {
      await (launchUrl(url, mode: LaunchMode.externalApplication));
    } else {
      final SnackBar showSnackBar = snackBar(
          context,
          'An error occured',
          5);
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Tips').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: widget.size.height * 0.25,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              height: widget.size.height * 0.25,
              child: Center(
                child: JumpingText(
                  'Error',
                  style: TextStyle(color: errorColor),
                ),
              ),
            );
          } else {
            if (!snapshot.hasData) {
              return SizedBox(
                height: widget.size.height * 0.25,
                child: const Text('No Tips Available, check back later'),
              );
            }
            final data = snapshot.data!.docs;
            return SizedBox(
              height: widget.size.height * 0.25,
              child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                        width: widget.size.width * 0.05,
                      ),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: ((context, index) {
                    return Stack(children: [
                      Container(
                        width: widget.size.width * 0.8,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => _lauchTipsUrl(data[index]['link'],
                            ),
                            child: Image.network(
                              data[index]['image'],
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      loadingProgress == null
                                          ? child
                                          : Center(
                                              child: CircularProgressIndicator(
                                                  color: primaryColor),
                                            ),
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                child: Text(
                                  'Error, might be your internet',
                                  style: TextStyle(color: errorColor),
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: widget.size.height * 0.02,
                        right: widget.size.height * 0.03,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                alignment: Alignment.centerRight,
                                width: widget.size.width * 0.55,
                                child: Text(
                                  data[index]['title'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.5,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic),
                                )),
                            Container(
                              alignment: Alignment.centerRight,
                              width: widget.size.width * 0.6,
                              child: Text(
                                data[index]['description'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  })),
            );
          }
        });
  }
}
