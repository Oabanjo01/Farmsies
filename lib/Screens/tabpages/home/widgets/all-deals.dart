// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'deal_item.dart';

class AllDeals extends StatelessWidget {
  const AllDeals({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const SizedBox(
              child: Center(
                child: Text(
                  'An error occured',
                ),
              ),
            );
          } else {
            final List list = snapshot.data!.docs;
            if (list.isEmpty) {
              return SizedBox(
                height: size.height * 0.3,
                child: const Center(
                  child: Text(
                    'No products available',
                  ),
                ),
              );
            }
            return SizedBox(
              child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                physics: const ScrollPhysics(
                  parent: NeverScrollableScrollPhysics(),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: size.height * 0.22,
                    crossAxisCount: 2,
                    crossAxisSpacing: size.width * 0.05,
                    mainAxisSpacing: size.width * 0.02),
                itemBuilder: (BuildContext ctx, int index) {
                  return DealItem(product: list[index]);
                },
                itemCount: list.length
              ),
            );
          }
        });
  }
}
