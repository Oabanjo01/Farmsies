import 'package:farmsies/Models/item-model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../Constants/othermethods.dart';
import '../../Widgets/headboard.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<ItemModel> food = [
    ItemModel(
        title: 'title',
        description: 'description',
        imagepath: 'https://images.unsplash.com/photo-1585540083814-ea6ee8af9e4f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8bmlnZXJpYXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
        id: 1,
        price: 100),
    ItemModel(
        title: 'title',
        description: 'description',
        imagepath: 'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8bWFya2V0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
        id: 2,
        price: 200),
    ItemModel(
        title: 'title',
        description: 'description',
        imagepath: 'https://images.unsplash.com/photo-1542838132-92c53300491e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8bWFya2V0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
        id: 2,
        price: 200),
    ItemModel(
        title: 'title',
        description: 'description',
        imagepath: 'https://images.unsplash.com/photo-1601599561213-832382fd07ba?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fG1hcmtldHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
        id: 2,
        price: 200),
    ItemModel(
        title: 'title',
        description: 'description',
        imagepath: 'https://images.unsplash.com/photo-1572816225927-d08fb138f2b2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8bmlnZXJpYXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
        id: 2,
        price: 200),
        ItemModel(
        title: 'title',
        description: 'description',
        imagepath: 'https://images.unsplash.com/photo-1565958923272-e96dbb1e8414?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fG5pZ2VyaWF8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
        id: 2,
        price: 200),
        
    ItemModel(
        title: 'title',
        description: 'description',
        imagepath: 'https://images.unsplash.com/photo-1533900298318-6b8da08a523e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bWFya2V0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
        id: 2,
        price: 200),
  ];

  @override
  void initState() {
    food.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final username = FirebaseAuth.instance.currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor.withOpacity(0.2),
        actions: [
          IconButton(
              tooltip: 'Log-out',
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.popAndPushNamed(context, '/loginScreen');
                } catch (e) {
                  print(e.toString());
                }
              },
              icon: Icon(
                Icons.logout_rounded,
                color: primaryColor,
              )),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: popupdialog(context),
          )
        ],
        elevation: 0,
      ),
      backgroundColor: secondaryColor,
      body: ListView(children: [
        Headboard(size: size, username: username),
        spacing(size: size, height: 0.02),
        Foodcategories(size: size, food: food),
        SizedBox(
          height: size.height * 0.02,
        ),
        Fooddex(size: size, food: food),
        SizedBox(
          height: size.height * 0.02,
        ),
        FoodforSale(size: size, food: food),
      ]),
    );
  }

  PopupMenuButton<int> popupdialog(BuildContext context) {
    return PopupMenuButton<int>(
              onSelected: (value) => onselected(context, value),
              elevation: 1,
              position: PopupMenuPosition.under,
              icon: Icon(Icons.more_vert_rounded, color: primaryColor),
              itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      child: Text('Order history'),
                      value: 0,
                    ),
                    const PopupMenuItem(
                      child: Text('Setting'),
                      value: 1,
                    ),
                    const PopupMenuItem(
                      child: Text('About developer'),
                      value: 2,
                    ),
                    const PopupMenuItem(
                      child: Text('App info'),
                      value: 3,
                    )
                  ]);
  }

  onselected(BuildContext context, value) {
    switch (value) {
      case 0:
        print(value);
        break;
      case 1:
        Navigator.pushNamed(context, '/settings');
        break;
      case 2:
        print(value);
        break;
      case 3:
        print(value);
        break;
      default:
    }
  }
}

class FoodforSale extends StatelessWidget {
  const FoodforSale({
    Key? key,
    required this.size,
    required this.food,
  }) : super(key: key);

  final Size size;
  final List<ItemModel> food;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: size.width * 0.03,
        right: size.width * 0.03,
      ),
      height: size.height * 0.5,
      child: GridView.builder(
          itemCount: food.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: size.height * 0.2,
            crossAxisCount: 2,
            crossAxisSpacing: size.width * 0.02,
            mainAxisSpacing: size.width * 0.02),
          itemBuilder: (BuildContext ctx, int index) {
            return Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Center(child: Text(food[index].title)),
            );
          }),
    );
  }
}

class Fooddex extends StatelessWidget {
  const Fooddex({
    Key? key,
    required this.size,
    required this.food,
  }) : super(key: key);

  final Size size;
  final List<ItemModel> food;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: size.width * 0.05,
        right: size.width * 0.05,
      ),
      child: GridView.builder(
          clipBehavior: Clip.antiAlias,
          scrollDirection: Axis.horizontal,
          itemCount: food.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, mainAxisSpacing: size.width * 0.02, mainAxisExtent: 
               size.width * 0.8,),
          itemBuilder: ((context, index) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ClipRRect(
                child: Image.network(
                  food[index].imagepath,
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            );
          })),
      height: size.height * 0.25,
    );
  }
}

class Foodcategories extends StatelessWidget {
  const Foodcategories({
    Key? key,
    required this.size,
    required this.food,
  }) : super(key: key);

  final Size size;
  final List<ItemModel> food;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
      child: Container(
        height: size.height * 0.1,
        child: ListView.separated(
            separatorBuilder: (context, index) =>
                SizedBox(width: size.width * 0.03),
            itemCount: food.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext ctx, index) {
              return Container(
                // margin: EdgeInsets.only(left: size.width * 0.04),
                // height: size.width * 0.1,
                width: size.width * 0.15,
                child: Center(
                  child: Text(food[index].id.toString()),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
              );
            }),
      ),
    );
  }
}
