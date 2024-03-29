import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Screens/tabpages/favourites/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:progress_indicators/progress_indicators.dart';

import '../../../../Constants/colors.dart';
import '../widgets/grid_view.dart';
import '../widgets/list_view.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  bool isListview = false;
  Methods method = Methods();

  @override
  void initState() {
    _getTogglemode();
    super.initState();
  }

  _getTogglemode() async {
    final bool toggleMode = await method.getCurrentTogglemode();
    setState(
      () {
        isListview = toggleMode;
      },
    );
  }

  Widget _buildOrders(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot,
    Size size,
    bool isListview,
    Brightness theme,
  ) {
    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final String uid = firebaseAuth.currentUser!.uid;
    if (snapshot.hasData) {
      final List list = snapshot.data!.docs;
      if (list.isEmpty) {
        return SliverFillRemaining(
          child: SizedBox(
            child: Center(
              child: Text(
                'No favourites here yet, check our catalogue',
                style: TextStyle(
                  color:
                      theme == Brightness.dark ? screenColor : primaryDarkColor,
                ),
              ),
            ),
          ),
        );
      }
      return SliverPadding(
        padding: const EdgeInsets.all(10),
        sliver: isListview
            ? Listview(
                size: size, snapshot: snapshot, uid: uid, context2: context)
            : Gridview(
                snapshot: snapshot, size: size, uid: uid, context2: context),
      );
    } else if (snapshot.hasError) {
      return const SliverToBoxAdapter(
          child: Center(
        child: Text('An error occured'),
      ));
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      );
    } else if (!snapshot.hasData) {
      return SliverFillRemaining(
        child: SizedBox(
          child: Center(
            child: Text(
              'No favourites here yet, check our catalogue',
              style: TextStyle(
                color:
                    theme == Brightness.dark ? screenColor : primaryDarkColor,
              ),
            ),
          ),
        ),
      );
    } else {
      return SliverFillRemaining(
        child: SizedBox(
          child: Center(
            child: Text(
              'Error',
              style: TextStyle(
                color:
                    theme == Brightness.dark ? screenColor : primaryDarkColor,
              ),
            ),
          ),
        ),
      );
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
              .collection('Favourites')
              .where('isFavourited', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  shape: const ContinuousRectangleBorder(),
                  backgroundColor:
                      theme == Brightness.dark ? screenDarkColor : screenColor,
                  expandedHeight: size.height * 0.3,
                  elevation: 0,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(
                        left: size.width * 0.05, bottom: size.width * 0.04),
                    collapseMode: CollapseMode.pin,
                    background: Stack(children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Opacity(
                          opacity: 0.15,
                          child: Image.asset('assets/farmer (1).png'),
                        ),
                      )
                    ]),
                    expandedTitleScale: 2,
                    title: Text(
                      'Favourites',
                      style: TextStyle(
                        fontSize: 20,
                        color: theme == Brightness.dark
                            ? textDarkColor
                            : textColor,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: size.width * 0.05),
                    child: IconButton(
                      color: Theme.of(context).iconTheme.color,
                      icon: isListview
                          ? const Icon(Icons.grid_view_rounded)
                          : const Icon(Icons.view_list_rounded),
                      onPressed: () async {
                        isListview = !isListview;
                        await method.saveTogglemode(isListview);
                        setState(() {});
                      },
                    ),
                  ),
                ),
                _buildOrders(context, snapshot, size, isListview, theme)
              ],
            );
          }),
    );
  }
}
