import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore=FirebaseFirestore.instance;

class StoreData{
  Future <String> UploadImageToStorage(String childName, Uint8List file) async{
    Reference ref= _storage.ref().child(childName+'.jpg');
    UploadTask uploadTask=ref.putData(file);
    TaskSnapshot snapshot= await uploadTask;
    String downloadUrl=await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  Future<String> saveData({
    required String id,
    required Uint8List file,
  }) async {
    String resp = "error occurred";
    try {
      // Check if there are existing images with the same ID
      final QuerySnapshot querySnapshot = await _firestore
          .collection("userProfile")
          .where('id', isEqualTo: id)
          .get();

      // If there are existing images, delete them
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      // Upload the new image
      String imageUrl = await UploadImageToStorage("ProfileImage", file);

      // Add the new image with the ID
      await _firestore.collection("userProfile").add({
        'id': id,
        'imageurl': imageUrl,
      });

      resp = 'success';
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }



  Future<String?> getImageUrl(String id) async {
    try {
      var snapshot = await _firestore
          .collection('userProfile')
          .where('id', isEqualTo: id)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()['imageurl'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}