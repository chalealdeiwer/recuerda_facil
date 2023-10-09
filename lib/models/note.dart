import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String title;
  final String content;
  final List<String> user;  // Ahora user es una lista de strings
  final String key;
  final DateTime dateCreate;
  final DateTime dateFinish;
  final bool stateDone;
  final String category;
  final String icon;  // Nuevo campo para el icono

  Note({
    required this.title,
    required this.content,
    required this.user,
    required this.key,
    required this.dateCreate,
    required this.dateFinish,
    required this.stateDone,
    required this.category,
    required this.icon,  // Nuevo argumento para el icono
  });

  factory Note.fromJson(Map<String, dynamic> json, String id) {
    return Note(
      title: json['title'],
      content: json['content'],
      user: List<String>.from(json['user']),  // Convertir a lista de strings
      key: id,
      dateCreate: (json['date_create'] as Timestamp).toDate(),
      dateFinish: (json['date_finish'] as Timestamp).toDate(),
      stateDone: json['stateDone'],
      category: json['category']??'',
      icon: json['icon']??'',  // Mapear el valor del icono
    );
  }
}