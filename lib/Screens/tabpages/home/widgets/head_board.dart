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
      padding: EdgeInsets.only(right: widget.size.width * 0.025, left: widget.size.width * 0.08),
      height: widget.size.height * 0.11,
      child: Row(children: [
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            height: widget.size.width * 0.17,
            width: widget.size.width * 0.17,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.network(imageUrl,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/Avatars/icons8-circled-user-male-skin-type-6-80.png',
                      ),
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
            ),
          ),
        ),
        SizedBox(
          width: widget.size.width * 0.05,
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
