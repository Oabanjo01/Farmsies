import 'package:basic_utils/basic_utils.dart';
import 'package:farmsies/Constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Headboard extends StatefulWidget {
  const Headboard({
    Key? key,
    required this.size,
    required this.username,
  }) : super(key: key);

  final Size size;
  final User? username;

  @override
  State<Headboard> createState() => _HeadboardState();
}

class _HeadboardState extends State<Headboard> {
  String imageUrl = '';
  getDownloadURL() async {
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    final url = await _firebaseStorage
        .ref()
        .child('Files/DisplayPictures/${widget.username!.uid}')
        .getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  @override
  void initState() {
    getDownloadURL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 20),
      height: widget.size.height * 0.1,
      child: Row(children: [
        CircleAvatar(
          // 'assets/Avatars/icons8-circled-user-male-skin-type-6-80.png'
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size.width * 0.1),
            child: Image.network(
              imageUrl,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/Avatars/icons8-circled-user-male-skin-type-6-80.png',
                        ),
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                      ? child
                      : const Center(
                        child: CircularProgressIndicator(),
                      )
            ),
          ),
          radius: widget.size.width * 0.1,
          backgroundColor: Colors.transparent,
        ),
        SizedBox(
          width: widget.size.width * 0.07,
        ),
        Expanded(
            child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Welcome ${StringUtils.capitalize(widget.username!.displayName!.toUpperCase())}',
            style: const TextStyle(fontSize: 20),
          ),
        ))
      ]),
    );
  }
}
