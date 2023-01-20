// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'deal_item.dart';

class AllDeals extends StatefulWidget {
  const AllDeals({
    Key? key,
    required this.size,
    required this.allProducts,
  }) : super(key: key);

  final Size size;
  final List allProducts;

  @override
  State<AllDeals> createState() => _AllDealsState();
}

class _AllDealsState extends State<AllDeals> {
  @override
  Widget build(BuildContext context) {
    if (widget.allProducts.isEmpty) {
      return SizedBox(
        height: widget.size.height * 0.3,
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
              mainAxisExtent: widget.size.height * 0.22,
              crossAxisCount: 2,
              crossAxisSpacing: widget.size.width * 0.05,
              mainAxisSpacing: widget.size.width * 0.02),
          itemBuilder: (BuildContext ctx, int index) {
            return DealItem(product: widget.allProducts[index]);
          },
          itemCount: widget.allProducts.length),
    );
    // builder: (context, snapshot) {
    //   if (snapshot.connectionState == ConnectionState.waiting) {
    //     return const SizedBox(
    //       child: Center(
    //         child: CircularProgressIndicator(),
    //       ),
    //     );
    //   } else if (snapshot.hasError) {
    //     return const SizedBox(
    //       child: Center(
    //         child: Text(
    //           'An error occured',
    //         ),
    //       ),
    //     );
    //   } else {
    //     final List list = snapshot.data!.docs;
    //     if (list.isEmpty) {
    //       return SizedBox(
    //         height: widget.size.height * 0.3,
    //         child: const Center(
    //           child: Text(
    //             'No products available',
    //           ),
    //         ),
    //       );
    //     }
    //     return SizedBox(
    //       child: GridView.builder(
    //         shrinkWrap: true,
    //         primary: false,
    //         physics: const ScrollPhysics(
    //           parent: NeverScrollableScrollPhysics(),
    //         ),
    //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //             mainAxisExtent: widget.size.height * 0.22,
    //             crossAxisCount: 2,
    //             crossAxisSpacing: widget.size.width * 0.05,
    //             mainAxisSpacing: widget.size.width * 0.02),
    //         itemBuilder: (BuildContext ctx, int index) {
    //           return DealItem(product: list[index]);
    //         },
    //         itemCount: list.length
    //       ),
    //     );
    //   }
    // });
  }
}
