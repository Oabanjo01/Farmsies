import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants/colors.dart';
import '../Utils/file_picker.dart';
import '../Utils/snack_bar.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  bool modify = false;
  bool modify1 = false;
  bool modify2 = false;

  bool switchicon = false;
  bool switchicon1 = false;
  bool switchicon2 = false;

  String imageUrl = '';

  TextEditingController userNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  final GlobalKey<FormState> _formKey2 = GlobalKey();

  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    getDownloadURL();
    getUserDetail();
    modify = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userNameController.addListener(() {
      setState(() {
        switchicon = userNameController.text.isNotEmpty;
      });
    });
    addressController.addListener(() {
      setState(() {
        switchicon1 = addressController.text.isNotEmpty;
      });
    });
    descriptionController.addListener(() {
      setState(() {
        switchicon2 = descriptionController.text.isNotEmpty;
      });
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    userNameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  getDownloadURL() async {
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
        query:
            'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(messageBody)}'
        // encodeQueryParameters(<String, String>{subject: messageBody}),
        // queryParameters: {subject: messageBody},
        );
    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
    } else {
      return;
    }
  }

  _validator(String? value, String? validatortext0, String? validatortext1,
      String? validatortext2, int? textLength) {
    if (value!.isEmpty) {
      return validatortext0;
    } else if (value.contains('@')) {
      // check if usename has a match on firebase already
      return validatortext1;
    } else if (value.length < textLength!) {
      // check if usename has a match on firebase already
      return validatortext2;
    }
  }

  bool _isUpdating = false;

  String description = '';
  String address = '';
  void getUserDetail() {
    _firestore
        .collection('Users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('User')
        .doc(_firebaseAuth.currentUser!.email)
        .collection('Business-details')
        .doc(_firebaseAuth.currentUser!.email)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data()!.containsKey('address') ||
            snapshot.data()!.containsKey('description')) {
          setState(() {
            address = snapshot.data()!['address'] ?? 'Address';
            description =
                snapshot.data()!['description'] ?? 'Business Description';
          });
        }
      } else {
        setState(() {
          address = 'Why not include an address?';
          description =
              'Bring your business to life with a business description';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).brightness;
    final firebaseUser = _firebaseAuth.currentUser!;
    final appBarHeight = MediaQuery.of(context).padding.top;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          setState(() {
            modify = false;
            modify1 = false;
            modify2 = false;
          });
        }
      },
      child: Scaffold(
          body: RefreshIndicator(
        onRefresh: () async {
          getDownloadURL();
          getUserDetail();
          final SnackBar showSnackBar = snackBar(context, 'Refreshed', 1,
              size.width * 0.3, primaryColor.withOpacity(0.1));
          ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(showSnackBar);
        },
        color: primaryColor.withOpacity(0.1),
        backgroundColor:
            theme == Brightness.dark ? screenDarkColor : screenColor,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            title: const Text('Your Account'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: primaryColor),
                onPressed: () => Navigator.pop(
                      context,
                    )),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: primaryColor,
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: size.height * 1.01 - appBarHeight,
              child: _isUpdating == true
                  ? Center(
                      child: Center(
                        child: Container(
                          width: size.width * 0.4,
                          height: size.width * 0.4,
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: primaryColor.withOpacity(0.2),
                          ),
                          child: JumpingText('Updating...'),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        spacing(
                          size,
                          0.04,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.08),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size.width * 0.2,
                                  height: size.width * 0.2,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(size.height * 1),
                                    child: InkWell(
                                      splashColor: primaryColor,
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () async {
                                        try {
                                          await pickFile(
                                            ctx: context,
                                            popBottomSheet: false,
                                            pickMultipleImages: false,
                                          ).then((value) async {
                                            if (value == '') {
                                              return;
                                            } else if (value ==
                                                'Something went wrong') {
                                              return;
                                            } else {
                                              setState(() {
                                                imageUrl = value!;
                                                _isUpdating = true;
                                              });
                                              await _firebaseStorage
                                                  .ref()
                                                  .child(
                                                      'Files/DisplayPictures/${_firebaseAuth.currentUser!.email}/${_firebaseAuth.currentUser!.uid}')
                                                  .delete()
                                                  .then((value) {
                                                File file = File(imageUrl);
                                                final SettableMetadata
                                                    metaData = SettableMetadata(
                                                        customMetadata: {
                                                      'Date': DateTime.now()
                                                          .toString()
                                                    });
                                                _firestore
                                                    .collection('Users')
                                                    .doc(_firebaseAuth
                                                        .currentUser!.uid)
                                                    .collection("User")
                                                    .doc(
                                                        '${_firebaseAuth.currentUser!.email}')
                                                    .update({
                                                  'displayPicture': imageUrl
                                                }).then((value) async {
                                                  await _firebaseStorage
                                                      .ref()
                                                      .child(
                                                          'Files/DisplayPictures/${_firebaseAuth.currentUser!.email}/${_firebaseAuth.currentUser!.uid}')
                                                      .putFile(file, metaData)
                                                      .then((p0) async {
                                                    await getDownloadURL();
                                                  }).then((value) {
                                                    setState(() {
                                                      _isUpdating = false;
                                                    });
                                                    final SnackBar
                                                        showSnackBar = snackBar(
                                                            context,
                                                            'Your display picture has been updated, you can only change this a few more times',
                                                            5);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        ..removeCurrentSnackBar()..showSnackBar(
                                                            showSnackBar);
                                                  });
                                                });
                                              });
                                            }
                                          });
                                        } catch (e) {}
                                      },
                                      child: Image.network(imageUrl,
                                          width: size.width * 0.12,
                                          alignment: Alignment.topCenter,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                    'assets/Avatars/icons8-circled-user-male-skin-type-6-80.png',
                                                  ),
                                          loadingBuilder: (context, child,
                                                  loadingProgress) =>
                                              loadingProgress == null
                                                  ? child
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.05,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          modify == false
                                              ? Text(
                                                  firebaseUser.displayName!,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              : Expanded(
                                                  child: Form(
                                                    key: _formKey,
                                                    child: TextFormField(
                                                      validator:
                                                          (String? value) {
                                                        return _validator(
                                                            value,
                                                            'Input you a username',
                                                            'invalid username',
                                                            'Username should be longer',
                                                            2);
                                                      },
                                                      onSaved: (newValue) {
                                                        userNameController
                                                            .text = newValue!;
                                                      },
                                                      cursorColor: primaryColor
                                                          .withOpacity(0.7),
                                                      controller:
                                                          userNameController,
                                                      maxLength: 15,
                                                      maxLines: 1,
                                                      decoration:
                                                          _textfieldDecoration(
                                                              'Username',
                                                              Icon(
                                                                Icons.person,
                                                                color:
                                                                    primaryColor,
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                          modify == false
                                              ? IconButton(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  onPressed: () {
                                                    setState(() {
                                                      modify = !modify;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.edit_rounded))
                                              : switchicon == true
                                                  ? IconButton(
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color,
                                                      onPressed: () async {
                                                        if (!_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          return;
                                                        }
                                                        {
                                                          setState(() {
                                                            _isUpdating = true;
                                                          });
                                                          try {
                                                            CollectionReference
                                                                users =
                                                                _firestore
                                                                    .collection(
                                                                        'Users');
                                                            firebaseUser
                                                                .updateDisplayName(
                                                                    userNameController
                                                                        .text)
                                                                .then(
                                                                    (value) async {
                                                              await users
                                                                  .doc(
                                                                      firebaseUser
                                                                          .uid)
                                                                  .collection(
                                                                      'User')
                                                                  .doc(firebaseUser
                                                                      .email)
                                                                  .update({
                                                                'username':
                                                                    userNameController
                                                                        .text
                                                              }).then((value) {
                                                                final SnackBar
                                                                    showSnackBar =
                                                                    snackBar(
                                                                        context,
                                                                        'Your Username has been updated!',
                                                                        1);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    ..removeCurrentSnackBar()..showSnackBar(
                                                                        showSnackBar);
                                                                setState(() {
                                                                  _isUpdating =
                                                                      false;
                                                                  modify =
                                                                      !modify;
                                                                });
                                                              });
                                                            });
                                                          } catch (e) {}
                                                        }
                                                      },
                                                      icon: const Icon(
                                                        Icons.check_rounded,
                                                      ),
                                                    )
                                                  : IconButton(
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color,
                                                      onPressed: () {
                                                        setState(() {
                                                          modify = !modify;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .catching_pokemon_rounded,
                                                      ),
                                                    ),
                                        ]),
                                  ),
                                )
                              ]),
                        ),
                        spacing(size, 0.04),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.08),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Address',
                                  style: TextStyle(
                                    
                                                    color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                const Divider(thickness: 1),
                                editableuserinfo(
                                    'Address', firebaseUser, _firestore,
                                    address: address),
                                spacing(size, 0.04),
                                Text(
                                  'A bit about my business',
                                  style: TextStyle(
                                                    color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                const Divider(thickness: 1),
                                editableuserinfo(
                                    'Description', firebaseUser, _firestore,
                                    description: description),
                              ]),
                        ),
                        spacing(size, 0.3),
                        SizedBox(
                          child: TextButton(
                            onPressed: (() => _launchMail(
                                email: 'banjolakunri@gmail.com',
                                messageBody:
                                    'Hello Olabanjo,\n I would like to delete my account',
                                subject: 'I would like to delete my account')),
                            child: Text(
                              'Delete your account?',
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          )
        ]),
      )),
    );
  }

  InputDecoration _textfieldDecoration(String text, Icon icon) {
    return InputDecoration(
        errorStyle: TextStyle(color: errorColor.withOpacity(0.8)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: errorColor.withOpacity(0.8), width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: errorColor.withOpacity(0.8), width: 1.5)),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: icon,
        ),
        prefixIconColor: primaryColor,
        focusColor: primaryColor,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryColor, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5)),
        labelText: text,
        labelStyle: TextStyle(color: primaryColor.withOpacity(0.6)));
  }

  SizedBox spacing(
    Size size,
    double height,
  ) {
    return SizedBox(
      child: SizedBox(
        height: size.height * height,
      ),
    );
  }

  Row editableuserinfo(text, User firebaseUser, FirebaseFirestore firestore,
      {String address = 'Address', String description = 'Description'}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text == 'Address'
            ? modify1 == false
                ? address.isEmpty
                    ? Text(address)
                    : Expanded(
                        child: Text(
                        address,
                      ))
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Form(
                        key: _formKey1,
                        child: TextFormField(
                          validator: (String? value) {
                            return _validator(
                                value,
                                'Input your address',
                                'invalid address',
                                'Please give a valid address',
                                10);
                          },
                          onSaved: (newValue) {
                            addressController.text = newValue!;
                          },
                          cursorColor: primaryColor.withOpacity(0.7),
                          controller: addressController,
                          maxLines: 2,
                          maxLength: 100,
                          decoration: _textfieldDecoration(
                              'Add an address',
                              Icon(
                                Icons.person,
                                color: primaryColor,
                              )),
                        ),
                      ),
                    ),
                  )
            : modify2 == false
                ? description.isEmpty
                    ? Text(description)
                    : Flexible(
                        child: Text(
                          description,
                        ),
                      )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Form(
                        key: _formKey2,
                        child: TextFormField(
                          validator: (String? value) {
                            return _validator(
                              value,
                              'Input your description',
                              'invalid description',
                              'A detailed description would help customers better understand your product',
                              20,
                            );
                          },
                          onSaved: (newValue) {
                            descriptionController.text = newValue!;
                          },
                          maxLength: 150,
                          cursorColor: primaryColor.withOpacity(0.7),
                          controller: descriptionController,
                          obscureText: false,
                          maxLines: 5,
                          decoration: _textfieldDecoration(
                              'Description',
                              Icon(
                                Icons.person,
                                color: primaryColor,
                              )),
                        ),
                      ),
                    ),
                  ),
        text == 'Address'
            ? modify1 == false
                ? IconButton(
                    color: Theme.of(context).iconTheme.color,
                    onPressed: () {
                      setState(() {
                        modify1 = !modify1;
                      });
                    },
                    icon: const Icon(Icons.edit_rounded))
                : switchicon1
                    ? IconButton(
                        color: Theme.of(context).iconTheme.color,
                        onPressed: () {
                          if (!_formKey1.currentState!.validate()) {
                            return;
                          }
                          {
                            try {
                              setState(() {
                                _isUpdating = true;
                              });
                              CollectionReference users =
                                  firestore.collection('Users');
                              CollectionReference collectionReference = users
                                  .doc(firebaseUser.uid)
                                  .collection('User')
                                  .doc(firebaseUser.email)
                                  .collection('Business-details');
                              collectionReference.get().then((value) async {
                                if (value.docs.isEmpty) {
                                  await collectionReference
                                      .doc(firebaseUser.email)
                                      .set({
                                    'address': addressController.text
                                  }).then((value) {
                                    final SnackBar showSnackBar = snackBar(
                                        context,
                                        'An address for your business has been has been updated!',
                                        1);
                                    ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()..showSnackBar(showSnackBar);
                                    setState(() {
                                      modify1 = !modify1;
                                    });
                                  });
                                } else {
                                  await collectionReference
                                      .doc(firebaseUser.email)
                                      .update({
                                    'address': addressController.text,
                                  }).then((value) {
                                    final SnackBar showSnackBar = snackBar(
                                        context,
                                        'An address for your business has been has been created!',
                                        1);
                                    ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()..showSnackBar(showSnackBar);
                                    setState(() {
                                      modify1 = !modify1;
                                      _isUpdating = false;
                                    });
                                    addressController.clear();
                                  });
                                }
                              });
                            } catch (e) {}
                          }
                        },
                        icon: const Icon(Icons.check_rounded))
                    : IconButton(
                        color: Theme.of(context).iconTheme.color,
                        onPressed: () {
                          setState(() {
                            modify1 = !modify1;
                          });
                        },
                        icon: const Icon(
                          Icons.catching_pokemon_rounded,
                        ),
                      )
            : modify2 == false
                ? SizedBox(
                    child: IconButton(
                        color: Theme.of(context).iconTheme.color,
                        onPressed: () {
                          setState(() {
                            modify2 = !modify2;
                          });
                        },
                        icon: const Icon(Icons.edit_rounded)),
                  )
                : switchicon2
                    ? IconButton(
                        color: Theme.of(context).iconTheme.color,
                        onPressed: () {
                          if (!_formKey2.currentState!.validate()) {
                            return;
                          }
                          {
                            try {
                              setState(() {
                                _isUpdating = true;
                              });
                              CollectionReference users =
                                  firestore.collection('Users');
                              CollectionReference collectionReference = users
                                  .doc(firebaseUser.uid)
                                  .collection('User')
                                  .doc(firebaseUser.email)
                                  .collection('Business-details');
                              collectionReference.get().then((value) async {
                                if (value.docs.isEmpty) {
                                  await collectionReference
                                      .doc(firebaseUser.email)
                                      .set({
                                    'description': descriptionController.text
                                  }).then((value) {
                                    final SnackBar showSnackBar = snackBar(
                                        context,
                                        'You have given your business a description, hurrayy!',
                                        1);
                                    ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()..showSnackBar(showSnackBar);
                                    setState(() {
                                      modify2 = !modify2;
                                    });
                                  });
                                } else {
                                  await collectionReference
                                      .doc(firebaseUser.email)
                                      .update({
                                    'description': descriptionController.text,
                                  }).then((value) {
                                    final SnackBar showSnackBar = snackBar(
                                        context,
                                        'Your description has been updated',
                                        1);
                                    ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()..showSnackBar(showSnackBar);
                                    setState(() {
                                      _isUpdating = false;
                                      modify2 = !modify2;
                                    });
                                    descriptionController.clear();
                                  });
                                }
                              });
                            } catch (e) {}
                          }
                        },
                        icon: const Icon(Icons.check_rounded))
                    : IconButton(
                        color: Theme.of(context).iconTheme.color,
                        onPressed: () {
                          setState(() {
                            modify2 = !modify2;
                          });
                        },
                        icon: const Icon(
                          Icons.catching_pokemon_rounded,
                        ),
                      )
      ],
    );
  }
}
