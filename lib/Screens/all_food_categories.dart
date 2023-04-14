import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Screens/tabpages/favourites/widgets/grid_view.dart';
import 'package:farmsies/Screens/tabpages/favourites/widgets/list_view.dart';
import 'package:farmsies/Screens/tabpages/home/widgets/deal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Constants/colors.dart';
import '../Constants/samples.dart';

class AllFoodCategories extends StatefulWidget {
  const AllFoodCategories({Key? key}) : super(key: key);

  @override
  State<AllFoodCategories> createState() => _AllFoodCategoriesState();
}

class _AllFoodCategoriesState extends State<AllFoodCategories>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 15, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  Stream<QuerySnapshot> getFoodItemsByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('Products')
        .where('category', isEqualTo: category)
        .snapshots();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = MediaQuery.of(context).platformBrightness;
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            
            title: const Text('Categories'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: primaryColor,
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: <Widget>[
                _tabs("All", _tabController, 0),
                _tabs(foodcategories[0]['food name'], _tabController, 1),
                _tabs(foodcategories[1]['food name'], _tabController, 2),
                _tabs(foodcategories[2]['food name'], _tabController, 3),
                _tabs(foodcategories[3]['food name'], _tabController, 4),
                _tabs(foodcategories[4]['food name'], _tabController, 5),
                _tabs(foodcategories[5]['food name'], _tabController, 6),
                _tabs(foodcategories[6]['food name'], _tabController, 7),
                _tabs(foodcategories[7]['food name'], _tabController, 8),
                _tabs(foodcategories[8]['food name'], _tabController, 9),
                _tabs(foodcategories[9]['food name'], _tabController, 10),
                _tabs(foodcategories[10]['food name'], _tabController, 11),
                _tabs(foodcategories[11]['food name'], _tabController, 12),
                _tabs(foodcategories[12]['food name'], _tabController, 13),
                _tabs(foodcategories[13]['food name'], _tabController, 14),
              ],
            ),
          ),
          SliverToBoxAdapter(
              child: SizedBox(
            height: size.height * 0.04,
          )),
          // DescriptionCard(size: size, text: 'FoodCategories'),
          SliverPadding(
            padding: EdgeInsets.only(
              left: size.height * 0.02,
              right: size.height * 0.02,
            ),
            sliver: SliverFillRemaining(
              child: TabBarView(controller: _tabController, children: <Widget>[
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: const ScrollPhysics(
                    parent: NeverScrollableScrollPhysics(),
                  ),
                  itemCount: foodcategories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: size.width * 0.03,
                      mainAxisSpacing: size.width * 0.03,
                      childAspectRatio: 0.8),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _tabController.animateTo(index + 1);
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(
                                size.width * 0.05,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.grey.shade300,
                                    primaryColor.withOpacity(0.08),
                                  ],
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: SvgPicture.asset(
                                foodcategories[index]['food icon'],
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: size.width * 0.25,
                            child: Chip(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              label: Text(
                                foodcategories[index]['food name'],
                                overflow: TextOverflow.fade,
                              ),
                              avatar: SvgPicture.asset(
                                foodcategories[index]['food icon'],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                _tabpages(foodcategories[0]['food name'], size, _tabController),
                _tabpages(foodcategories[1]['food name'], size, _tabController),
                _tabpages(foodcategories[2]['food name'], size, _tabController),
                _tabpages(foodcategories[3]['food name'], size, _tabController),
                _tabpages(foodcategories[4]['food name'], size, _tabController),
                _tabpages(foodcategories[5]['food name'], size, _tabController),
                _tabpages(foodcategories[6]['food name'], size, _tabController),
                _tabpages(foodcategories[7]['food name'], size, _tabController),
                _tabpages(foodcategories[8]['food name'], size, _tabController),
                _tabpages(foodcategories[9]['food name'], size, _tabController),
                _tabpages(
                    foodcategories[10]['food name'], size, _tabController),
                _tabpages(
                    foodcategories[11]['food name'], size, _tabController),
                _tabpages(
                    foodcategories[12]['food name'], size, _tabController),
                _tabpages(
                    foodcategories[13]['food name'], size, _tabController),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  SizedBox _tabpages(String text, Size size, TabController controller) {
    return SizedBox(
        child: StreamBuilder(
            stream: getFoodItemsByCategory(text),
            builder:
                ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active) {
                final List<QueryDocumentSnapshot<Object?>> data =
                    snapshot.data!.docs;
                if (data.isEmpty) {
                  return const Center(
                    child: Text(
                        'No items in this category, for now. Check back later'),
                  );
                }
                return GridView.builder(
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
                      return DealItem(product: data[index]);
                    },
                    itemCount: data.length);
              } else {
                return Text(
                  'An unexpected issue came up',
                  style: TextStyle(color: errorColor),
                );
              }
            })));
  }

  Tab _tabs(String text, TabController controller, int index) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(
            color: controller.index == index ? primaryColor : Colors.black),
      ),
    );
  }
}
