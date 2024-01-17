import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> loadMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<String> getOtherUserIdInChat(String chatId, String currentUserId) async {
  final chatDoc = await _firestore.collection('chats').doc(chatId).get();

  if (chatDoc.exists) {
    final List<dynamic> users = chatDoc.data()?['users'];

    // Encuentra el ID del otro usuario en el chat
    final otherUserId = users.firstWhere((userId) => userId != currentUserId, orElse: () => '');

    return otherUserId;
  } else {
    return ''; // Si el chat no existe o no se encuentra, devuelve una cadena vacía o maneja el caso según tu lógica
  }
}

  Future<void> sendMessage(
      String chatId, String senderId, String message) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'message': message,
      'timestamp': Timestamp.now(),
    });
  }

  Future<String> createChat(String userId1, String userId2) async {
    // Ordena los IDs para mantener consistencia en la búsqueda del chat
    List<String> sortedIds = [userId1, userId2]..sort();

    final chatSnapshot = await _firestore
        .collection('chats')
        .where('users', isEqualTo: sortedIds)
        .get();

    if (chatSnapshot.docs.isNotEmpty) {
      // Ya existe un chat entre estos usuarios, puedes devolver el ID del chat existente
      return chatSnapshot.docs[0].id;
    } else {
      // Si no existe un chat entre estos usuarios, crea uno nuevo
      final chatDocRef = await _firestore.collection('chats').add({});
      final chatId = chatDocRef.id;

      await _firestore.collection('chats').doc(chatId).set({
        'users': sortedIds,
        // Otros datos relevantes para el chat
      });

      // Actualiza la información en las colecciones de usuarios
      await _firestore
          .collection('users')
          .doc(userId1)
          .collection('chats')
          .doc(chatId)
          .set({});
      await _firestore
          .collection('users')
          .doc(userId2)
          .collection('chats')
          .doc(chatId)
          .set({});

      return chatId;
    }
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  Future<void> deleteChat(String chatId, String userId1, String userId2) async {
    await _firestore.collection('chats').doc(chatId).delete();
    await _firestore
        .collection('users')
        .doc(userId1)
        .collection('chats')
        .doc(chatId)
        .delete();
    await _firestore
        .collection('users')
        .doc(userId2)
        .collection('chats')
        .doc(chatId)
        .delete();
  }

  Stream<QuerySnapshot> loadAllChats(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        // .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Otros métodos que puedas necesitar para editar mensajes, obtener información de usuarios, etc.
}
