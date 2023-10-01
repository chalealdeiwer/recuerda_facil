import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount {
  final String? uid;
  final String? photoURL;
  final bool? emailVerified;
  final bool? private;
  final String? displayName;
  final DateTime? created; // Cambiado a DateTime
  final List<String>? categories;
  final String? email;
  final String? coverPhotoURL;

   UserAccount({
    this.uid = 'Sin nombre',
    this.photoURL = 'Sin foto',
    this.emailVerified = false,
    this.private = false,
    this.displayName = 'Sin nombre de Usuario',
    this.created,  // Fecha arbitraria
    this.categories = const [],
    this.email = 'Sin email',
    this.coverPhotoURL = 'https://i.pinimg.com/736x/e8/9b/a4/e89ba41407fb258daa464ba2e7aa27e2.jpg',
  });

  // Constructor que crea un Usuario a partir de un mapa
   UserAccount.fromMap(Map<String, dynamic> map)
      : uid = map['uid'] ?? 'Sin nombre',
        photoURL = map['photoURL'] ?? 'Sin foto',
        emailVerified = map['emailVerified'] ?? false,
        private = map['private'] ?? false,
        displayName = map['displayName'] ?? 'Sin nombre de usuario',
        created = (map['created'] as Timestamp?)?.toDate() ?? DateTime(2000, 1, 1),  // Fecha arbitraria
        categories = List<String>.from(map['categories'] ?? const []),
        email = map['email'] ?? 'Sin email',
        coverPhotoURL = map['coverPhotoURL'] ?? 'https://i.pinimg.com/736x/e8/9b/a4/e89ba41407fb258daa464ba2e7aa27e2.jpg';

}
