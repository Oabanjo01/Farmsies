import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:url_launcher/url_launcher.dart';

import '../Constants/colors.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  String imageUrl = '';
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  getDownloadURL() async {
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    final url = await _firebaseStorage
        .ref()
        .child(
            'Files/DisplayPictures/${_firebaseAuth.currentUser!.email}/${_firebaseAuth.currentUser!.uid}')
        .getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }
    Future _launchMail(
      {required String email,
      required String subject,
      required String messageBody}) async {
    final url =
        'mailto: $email?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(messageBody)}';
    final Uri mailtoUri = Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=' +
            Uri.encodeComponent(subject) +
            '&body=' +
            Uri.encodeComponent(messageBody)
        // encodeQueryParameters(<String, String>{subject: messageBody}),
        // queryParameters: {subject: messageBody},
        );
    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
    } else {
      return;
    }
  }

  @override
  void initState() {
    getDownloadURL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = MediaQuery.of(context).platformBrightness;

    final firebaseUser = _firebaseAuth.currentUser!;
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
        title: const Text('Your Account'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
      ),
      SliverToBoxAdapter(child: spacing(size, 0.04)),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              width: size.width * 0.2,
              height: size.width * 0.2,
              decoration:
                  BoxDecoration(color: primaryColor, shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size.height * 1),
                child: Image.network(imageUrl,
                    width: size.width * 0.12,
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
            SizedBox(
              width: size.width * 0.05,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      firebaseUser.displayName!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.edit_rounded))
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
      SliverToBoxAdapter(
        child: spacing(size, 0.04)
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'My Address',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const Divider(thickness: 1),
            editable_useInfo('Address'),
            spacing(size, 0.04),
            const Text(
              'A bit about my business',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const Divider(thickness: 1),
            editable_useInfo('I need a description for my business'),
          ]),
        ),
      ),
      SliverToBoxAdapter(child: spacing(size, 0.4)),
      SliverToBoxAdapter(
                child: SizedBox(
                  child: TextButton(
                    child: const Text('Contact us'),
                    onPressed: (() => _launchMail(
                        email: 'banjolakunri@gmail.com',
                        messageBody:
                            'Hello Olabanjo,\n I would like to make enquiries',
                        subject: 'I need more info')),
                  ),
                ),
              ),
    ]));
  }

  SizedBox spacing(Size size, double height, ) {
    return SizedBox(
            child: SizedBox(
              height: size.height * height,
            ),
          );
  }

  Row editable_useInfo(text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.edit_rounded,
          ),
        ),
      ],
    );
  }
}
