// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Provider/item_provider..dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Utils/snack_bar.dart';
import '../widgets/no_orders.dart';

class Orderspage extends StatefulWidget {
  const Orderspage({Key? key}) : super(key: key);

  @override
  State<Orderspage> createState() => _OrderspageState();
}

class _OrderspageState extends State<Orderspage> {
  Widget _buildOrders(
      BuildContext context2,
      AsyncSnapshot<QuerySnapshot> snapshot,
      Size size,
      List? list,
      Brightness theme,
      String uid) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SliverToBoxAdapter(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    } else if (snapshot.hasError) {
      return NoOrders(
        size: size,
        text: 'Error!',
      );
    } else {
      if (list!.isEmpty) {
        return NoOrders(
          text: 'Empty, head over to the homepage to make an order!',
          size: size,
        );
      } else {
        return SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              ((context, index) {
                final provider = Provider.of<Itemprovider>(context);
                return Container(
                  margin: EdgeInsets.only(bottom: size.height * 0.015),
                  decoration: BoxDecoration(
                    color: theme == Brightness.light
                        ? Colors.grey.withOpacity(0.1)
                        : screenColor.withOpacity(0.06),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: size.height * 0.005,
                        horizontal: size.width * 0.051),
                    leading: CircleAvatar(
                      radius: size.width * 0.06,
                      backgroundColor: theme == Brightness.dark
                          ? screenDarkColor
                          : screenColor,
                      backgroundImage: NetworkImage(list[index]['imagepath']),
                    ),
                    title: Text(list[index]['title']),
                    subtitle: Text(
                      '₦${(list[index]['price'] * list[index]['amount'])}'
                          .toString(),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        provider.toggler(list[index], uid, 'Orders', 1, context,
                            'Removed from Carts', 'Removed from Carts');
                      },
                      icon: Icon(
                        Icons.delete,
                        color: errorColor,
                      ),
                    ),
                  ),
                );
              }),
              childCount: list.length,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).brightness;
    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final String uid = firebaseAuth.currentUser!.uid;

    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .collection('Orders')
                .snapshots(),
            builder: (context, snapshot) {
              final List list = snapshot.data?.docs ?? [];

              double totalPrice = 0;
              list.forEach((element) async {
                totalPrice += element['price'] * element['amount'];
              });
              return RefreshIndicator(
                onRefresh: () async {
                  final SnackBar showSnackBar = snackBar(context, 'Refreshed', 1,
                      size.width * 0.3, primaryColor.withOpacity(0.1));
                  ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(showSnackBar);
                },
                color: primaryColor.withOpacity(0.1),
                backgroundColor:
                    theme == Brightness.dark ? screenDarkColor : screenColor,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Text(
                        'Orders',
                        style: TextStyle(
                          color: theme == Brightness.dark
                              ? screenColor
                              : primaryDarkColor,
                        ),
                      ),
                      backgroundColor: theme == Brightness.dark
                          ? primaryDarkColor
                          : Colors.white,
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: size.height * 0.02),
                    ),
                    SliverToBoxAdapter(
                      child: ListTile(
                        title: const Text('Delivery Address'),
                        subtitle: Text(
                          'Sample Address',
                          style: TextStyle(color: primaryColor),
                        ),
                        trailing: TextButton(
                          child: Text(
                            'change',
                            style: TextStyle(color: primaryColor),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/userAccount');
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: size.height * 0.02),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Orders',
                              style: TextStyle(fontSize: 20),
                            ),
                            Icon(Icons.question_mark)
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: size.height * 0.025),
                    ),
                    _buildOrders(context, snapshot, size, list, theme, uid),
                    SliverToBoxAdapter(
                      child: SizedBox(height: size.height * 0.02),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total amount'),
                                  Text('₦$totalPrice'),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total orders'),
                                  Text(
                                    '${list.length} items in total',
                                    style: TextStyle(
                                        color: primaryColor, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            SizedBox(
                              width: size.width * 0.65,
                              height: size.height * 0.06,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  foregroundColor:
                                      MaterialStateProperty.all(theme == Brightness.light ? textColor : textDarkColor),
                                  backgroundColor:
                                      MaterialStateProperty.all(primaryColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                onPressed: list.isEmpty
                                    ? null
                                    : () {
                                        Navigator.of(context)
                                            .pushNamed('/orderComplete');
                                      },
                                child: list.isEmpty
                                    ? const Text('No orders')
                                    : const Text('Order'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: size.height * 0.04),
                    ),
                  ],
                ),
              );
            }));
  }
}

// CustomScrollView(
//       slivers: [
//         const SliverAppBar(
//           title: Text('Orders'),
//         ),
//         SliverPadding(
//           padding: EdgeInsets.symmetric(
//             horizontal: size.width * 0.05,
//           ),
//           sliver: const SliverFillRemaining(
//             child: Center(child: Text('No Orders currently')),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: SizedBox(height: size.height * 0.05),
//         ),
//         SliverPadding(
//           padding: EdgeInsets.symmetric(
//             horizontal: size.width * 0.05,
//           ),
//           sliver: SliverToBoxAdapter(
//             child: ListTile(
//               title: const Text('Delivery Address'),
//               subtitle: const Text('Sample Address'),
//               trailing: TextButton(child: const Text('change'), onPressed: () {},),
//             ),
//           ),
//         ),
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             ((context, index) {
//               return Column(
//                 children: [
//                   Container(

//                   )
//                 ],
//               );
//             }),
//           ),
//         )
//       ],
//     )
