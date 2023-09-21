import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String id;
  String displayName;
  String photoURL;
  String email;

  User({ 
    required this.id, 
    required this.displayName, 
    required this.photoURL,
    required this.email,
  });

  factory User.fromFirestore(DocumentSnapshot userDoc) {
    Map userData = userDoc.data as Map;
    return User(
      id: userDoc.id,
      displayName: userData['displayName'],
      photoURL: userData['photoURL'],
      email: userData['email'],
    );
  }

  void setFromFireStore(DocumentSnapshot userDoc) {
    Map userData = userDoc.data as Map;
    this.id = userDoc.id;
    this.displayName = userData['displayName'];
    this.photoURL = userData['photoURL'];
    this.email = userData['email'];
    notifyListeners();
  }
}