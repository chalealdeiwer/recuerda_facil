import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveComment(String name, String comment, int rating, DateTime dateCreate) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    final CollectionReference commentsCollection = firestore.collection('comments');

    final DocumentReference newCommentRef = commentsCollection.doc();

    final Map<String, dynamic> data = {
      'name': name,
      'comment': comment,
      'rating': rating,
      'dateCreate': dateCreate,
    };

    await newCommentRef.set(data);

  } catch (e) {
    Exception(e);
  }
}