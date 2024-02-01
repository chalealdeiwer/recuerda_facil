import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> loadMessages(String boardId) {
    return _firestore
        .collection('boards')
        .doc(boardId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<Map<String, dynamic>> getBoardInfo(String boardId) async {
    final boardDoc = await _firestore.collection('boards').doc(boardId).get();

    if (boardDoc.exists) {
      return boardDoc.data() as Map<String, dynamic>;
    } else {
      throw Exception('El tablero con el ID $boardId no existe.');
    }
  }

  Stream<List<Map<String, dynamic>>> streamUserBoards(String userId) {
    return _firestore
        .collection('boards')
        .where('users', arrayContains: userId)
        .snapshots()
        .map((QuerySnapshot boardSnapshots) {
      List<Map<String, dynamic>> userBoards = [];

      for (QueryDocumentSnapshot boardSnapshot in boardSnapshots.docs) {
        Map<String, dynamic> boardData =
            boardSnapshot.data() as Map<String, dynamic>;
        userBoards.add(boardData);
      }

      return userBoards;
    });
  }

  Future<void> sendMessage(String boardId, String senderId, String displayName,
      String userPhoto, String message) async {
    await _firestore
        .collection('boards')
        .doc(boardId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'displayName': displayName,
      'userPhoto': userPhoto,
      'message': message,
      'timestamp': Timestamp.now(),
    });
  }

  Future<String> createBoard(String boardName, String creatorUserId,
      String displayName, String userPhoto) async {
    String boardId = generateRandomCode();
    List<String> users = [creatorUserId];

    Map<String, dynamic> boardData = {
      'id': boardId,
      'name': boardName,
      'users': users,
    };

    await _firestore.collection('boards').doc(boardId).set(boardData);

    // Añadir al creador al tablero
    await addUserToBoard(boardId, creatorUserId);

    // Enviar mensaje inicial
    String initialMessage = '¡Bienvenido al tablero!';
    await sendMessage(
        boardId, creatorUserId, displayName, userPhoto, initialMessage);

    return boardId;
  }

  Future<void> addUserToBoard(String boardId, String userId) async {
    await _firestore.collection('boards').doc(boardId).update({
      'users': FieldValue.arrayUnion([userId]),
    });
  }
   Future<bool> doesBoardExist(String boardId) async {
    try {
      final boardDoc = await _firestore.collection('boards').doc(boardId).get();
      return boardDoc.exists;
    } catch (e) {
      // Manejar cualquier error según tus necesidades
      return false;
    }
  }

  Future<bool> doesUserExistInBoard(String boardId, String userId) async {
    try {
      final boardDoc = await _firestore.collection('boards').doc(boardId).get();

      if (boardDoc.exists) {
        final List<dynamic> users = boardDoc.data()?['users'];
        return users.contains(userId);
      } else {
        return false;
      }
    } catch (e) {
      // Manejar cualquier error según tus necesidades
      return false;
    }
  
}
Future<void> removeUserFromBoard(String boardId, String userId) async {
  try {
    await _firestore.collection('boards').doc(boardId).update({
      'users': FieldValue.arrayRemove([userId]),
    });
  } catch (e) {
    // Manejar cualquier error según tus necesidades
  }
}

  String generateRandomCode() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    String code = '';
    for (int i = 0; i < 4; i++) {
      code += chars[random.nextInt(chars.length)];
    }
    return code;
  }

  // Otros métodos según sea necesario
}
