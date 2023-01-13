import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FileProvider with ChangeNotifier {
  bool _status = false;

  bool get status => _status;

  String _message = '';

  String get message => _message;

  String _displayPicUrl = '';

  String get displayPicUrl => _displayPicUrl;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Future<String> addImagetoStorage(String filePath, String fileName) async {
  //   File filepath = File(filePath);
  //   try {
  //     await _firebaseStorage.ref('tee').putFile(filepath);
  //   } catch (e) {
      
  //   }
  // }

  Future<String?> pickFile(BuildContext ctx) async {
    try {
      FilePickerResult? pickerResult = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);
      if (pickerResult != null) {
        String? pickedFile = pickerResult.files.single.path;
        Navigator.of(ctx).pop();
        return pickedFile;
      } else {
        return '';
      }
    } catch (e) {
      return 'Something went wrong';
    }
  }

  Future <void> displayPicture (storgeId, userId) async{
    final result = await _firebaseStorage.ref().child('DisplayPictures');
    // final picture = result.items.where((element) => element.name == userId);
  }

  Future<String> addDisplaypic(File displayPic, String uid) async {
    _status = true;
    CollectionReference _displayPictures =
        _firestore.collection('DisplayPictures');

    try {
      _message = 'Uploading image';
      final imagePath = uid.split('/');
      await _firebaseStorage
          .ref()
          .child('$uid/DisplayPicture/$imagePath')
          .putFile(displayPic)
          .whenComplete(() async {
        await _firebaseStorage
            .ref('$uid/DisplayPicture/$imagePath')
            .getDownloadURL()
            .then((value) {
          _displayPicUrl = value;
        });
      });
      _status = false;
      notifyListeners();
      return 'Uploaded';
    } on SocketException catch (e) {
      _status = false;
      _message = e.toString();
      notifyListeners();
      return 'Something might be wrong with your internet connection';
    } on FirebaseException catch (e) {
      _status = false;
      _message = e.toString();
      return 'Something went wrong';
    } catch (e) {
      _status = false;
      _message = e.toString();
      return _message;
    }
  }
}
