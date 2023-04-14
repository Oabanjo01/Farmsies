import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Constants/samples.dart';
import 'package:farmsies/Provider/file_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../Utils/snack_bar.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String image = '';
  bool _isLoading = false;
  String _dropdownItem = "";

  @override
  void initState() {
    super.initState();
    _dropdownItem = foodcategories.first["food name"];
    print(foodcategories.first["food name"]);
  }

  final GlobalKey<FormState> _globalKey = GlobalKey();

  String url = '';
  Future<String> getDownloadURL(email, uid) async {
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    final imageurl = await _firebaseStorage
        .ref()
        .child('Files/ProductPictures/$email/$uid-${titleController.text}')
        .getDownloadURL();
    setState(() {
      url = imageurl;
    });
    return url;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final String? email = firebaseAuth.currentUser!.email;
    final String? user = firebaseAuth.currentUser!.displayName;
    final String? uid = firebaseAuth.currentUser!.uid;
    final String date = DateTime.now().toIso8601String().split('T').first;
    return SafeArea(
      top: true,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: Form(
            key: _globalKey,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('Create your item'),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  foregroundColor: primaryColor,
                ),
                SliverToBoxAdapter(
                  child: image == ''
                      ? const SizedBox()
                      : Container(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.05),
                              gradient: LinearGradient(
                                colors: [
                                  screenColor.withOpacity(0.3),
                                  primaryDarkColor.withOpacity(0.2)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.08),
                          height: size.height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(size.width * 0.05),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              alignment: Alignment.centerRight,
                              image: FileImage(
                                File(image),
                              ),
                            ),
                            color: Colors.transparent,
                          ),
                          width: double.infinity,
                        ),
                ),
                _inputDescription(size, 'Name of your product'),
                _spacings(size, 0.01),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  sliver: SliverToBoxAdapter(
                    child: TextFormField(
                      cursorColor: primaryDarkColor,
                      controller: titleController,
                      maxLines: 1,
                      validator: ((String? value) {
                        if (value!.isEmpty) {
                          return 'This field cannot be empty.';
                        } else if (value.length <= 4) {
                          return 'Your product name could be more descriptive';
                        }
                      }),
                      onSaved: (newValue) {
                        titleController.text = newValue!;
                      },
                      decoration: _inputStyle(size, 'Product title'),
                    ),
                  ),
                ),
                _inputDescription(size, 'Describe your product'),
                _spacings(size, 0.01),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  sliver: SliverToBoxAdapter(
                    child: TextFormField(
                      cursorColor: primaryDarkColor,
                      controller: descriptionController,
                      maxLines: 6,
                      validator: ((String? value) {
                        if (value!.isEmpty) {
                          return 'This field cannot be empty.';
                        } else if (value.length <= 20) {
                          return 'Your product description could be more descriptive';
                        }
                      }),
                      onSaved: (newValue) {
                        descriptionController.text = newValue!;
                      },
                      decoration: _inputStyle(size, 'Product description'),
                    ),
                  ),
                ),
                _inputDescription(size, 'How much does each cost?'),
                _spacings(size, 0.01),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  sliver: SliverToBoxAdapter(
                    child: TextFormField(
                      cursorColor: primaryDarkColor,
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      maxLength: 10,
                      validator: ((String? value) {
                        if (value!.isEmpty) {
                          return 'This field cannot be empty.';
                        } else if (value.length <= 2) {
                          return 'You are bigger than this sir/ma.';
                        }
                      }),
                      onSaved: (newValue) {
                        priceController.text = newValue!;
                      },
                      decoration: _inputStyle(size, 'Product price'),
                    ),
                  ),
                ),
                _inputDescription(
                    size, 'How much of this product do you have?'),
                _spacings(size, 0.01),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  sliver: SliverToBoxAdapter(
                    child: TextFormField(
                      cursorColor: primaryDarkColor,
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      maxLength: 10,
                      validator: ((String? value) {
                        if (value!.isEmpty) {
                          return 'This field cannot be empty.';
                        } else if (value.isEmpty) {
                          return 'You are bigger than this sir/ma.';
                        }
                      }),
                      onSaved: (newValue) {
                        amountController.text = newValue!;
                      },
                      decoration: _inputStyle(size, 'Product amount'),
                    ),
                  ),
                ),
                _inputDescription(size, 'How would you classify your product?'),
                _spacings(size, 0.02),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, strokeAlign: StrokeAlign.center, color: primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: size.width * 0.2),
                      child: DropdownButton<String>(
                        underline: Container(),
                          iconEnabledColor: primaryColor,
                          focusColor: primaryColor,
                          iconSize: 30,
                          isExpanded: true,
                          value: _dropdownItem,
                          items: foodcategories
                              .map<DropdownMenuItem<String>>((category) {
                            return DropdownMenuItem(
                              child: Text(
                                category["food name"],
                              ),
                              value: category["food name"],
                            );
                          }).toList(),
                          onChanged: (e) {
                            setState(() {
                              _dropdownItem = e!;
                            });
                          }),
                    ),
                  ),
                ),
                _spacings(size, 0.02),
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: size.height * 0.08,
                      width: size.width * 0.35,
                      child: LayoutBuilder(
                        builder: (context, constraint) {
                          return IconButton(
                            splashRadius: size.width * 0.14,
                            splashColor: primaryColor.withOpacity(0.5),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MaterialButton(
                                        minWidth: size.width * 0.2,
                                        shape: const CircleBorder(),
                                        onPressed: () {
                                          Provider.of<FileProvider>(context,
                                                  listen: false)
                                              .pickFile(context)
                                              .then((value) {
                                            setState(() {
                                              image = value!;
                                            });
                                          }).catchError((e) {
                                            showDialog(
                                                context: context,
                                                builder: (builder) {
                                                  return AlertDialog(
                                                    content: Text(e),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Ok!'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          });
                                        },
                                        child: Icon(
                                          Icons.file_download,
                                          size: constraint.biggest.width,
                                          color: primaryColor.withOpacity(0.6),
                                        ),
                                      ),
                                      MaterialButton(
                                        minWidth: size.width * 0.2,
                                        shape: const CircleBorder(),
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.camera_outlined,
                                          size: constraint.biggest.width,
                                          color: primaryColor.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.camera,
                              size: constraint.biggest.height,
                              color: primaryDarkColor.withOpacity(0.7),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                _spacings(size, 0.03),
                SliverToBoxAdapter(
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.6,
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
                    child: _isLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<StadiumBorder>(
                                const StadiumBorder(),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                primaryColor,
                              ),
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (!_globalKey.currentState!.validate()) {
                                return;
                              } else {
                                _globalKey.currentState!.save();
                                setState(() {});
                                try {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  final SettableMetadata metaData =
                                      SettableMetadata(customMetadata: {
                                    'Date': DateTime.now().toString()
                                  });
                                  File file = File(image);
                                  await FirebaseStorage.instance
                                      .ref()
                                      .child(
                                          'Files/ProductPictures/$email/$uid-${titleController.text}')
                                      .putFile(file, metaData)
                                      .then((p0) async {
                                    await getDownloadURL(email, uid)
                                        .then((value) {
                                      FirebaseFirestore.instance
                                          .collection("Products")
                                          .doc(
                                              '$email-$date-${titleController.text}')
                                          .set({
                                        'id':
                                            '$email-$date-${titleController.text}',
                                        'title':
                                            titleController.text.toString(),
                                        'price':
                                            int.parse(priceController.text),
                                        'amount':
                                            int.parse(amountController.text),
                                        'date': DateTime.now()
                                            .toIso8601String()
                                            .split('T')
                                            .first,
                                        'itemCreator': user,
                                        'description': descriptionController
                                            .text
                                            .toString(),
                                        'email': email,
                                        'imagepath': value,
                                        'isFavourited': false,
                                        'isCarted': false,
                                        'category': _dropdownItem
                                      }).then((value) {
                                        setState(() {
                                          _isLoading = false;
                                        });

                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/homepage',
                                          (route) => false,
                                        );
                                        final SnackBar showSnackBar = snackBar(
                                            'Your Item has been created', 1);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(showSnackBar);
                                      });
                                    });
                                  });
                                } catch (e) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  final SnackBar showSnackBar =
                                      snackBar('There was an error', 1);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(showSnackBar);
                                }
                              }
                              ;
                            },
                            child: Text(
                              'Create Product',
                              style: TextStyle(
                                  fontSize: 17, color: primaryDarkColor),
                            ),
                          ),
                  ),
                ),
                _spacings(size, 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _spacings(Size size, double height) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: size.height * height,
      ),
    );
  }

  SliverPadding _inputDescription(Size size, String text) {
    return SliverPadding(
      padding: EdgeInsets.only(left: size.width * 0.08, top: size.width * 0.03),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          height: size.height * 0.03,
        ),
      ),
    );
  }

  InputDecoration _inputStyle(Size size, String text) {
    return InputDecoration(
        contentPadding: EdgeInsets.only(
          left: size.width * 0.07,
          top: size.height * 0.02,
          bottom: size.height * 0.02,
        ),
        labelText: text,
        alignLabelWithHint: true,
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryDarkColor, width: 0.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: errorColor, width: 0.3)),
        labelStyle: TextStyle(
          color: primaryColor,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryDarkColor, width: 0.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryDarkColor, width: 0.3)));
  }
}
