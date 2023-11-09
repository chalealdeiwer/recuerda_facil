import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore dbb = FirebaseFirestore.instance;

Future<bool> uploadProfilePhoto(String uid, File image) async {
  try {
    final String fileName = image.path.split("/").last;
    final Reference ref = storage.ref().child(uid).child('images').child('profilePicture').child(fileName);
    final UploadTask uploadTask = ref.putFile(image);

    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();

    if (snapshot.state == TaskState.success) {
      // Actualizar la referencia de la imagen en la base de datos
      final DocumentReference userDocRef = dbb.collection("users").doc(uid);
      await userDocRef.update({'photoURL': downloadUrl});
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
Future<bool> uploadCoverPhoto(String uid, File image) async {
  try {
    final String fileName = image.path.split("/").last;
    // Cambiando 'profilePicture' a 'coverPhoto'
    final Reference ref = storage.ref().child(uid).child('images').child('coverPhoto').child(fileName);
    final UploadTask uploadTask = ref.putFile(image);

    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();

    if (snapshot.state == TaskState.success) {
      // Actualizar la referencia de la imagen en la base de datos
      final DocumentReference userDocRef = dbb.collection("users").doc(uid);
      await userDocRef.update({'coverPhotoURL': downloadUrl});  // Cambiando 'photoURL' a 'coverPhotoURL'
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}