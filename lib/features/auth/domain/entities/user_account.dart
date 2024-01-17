import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount {
  final String? uid;
  final String? photoURL;
  final bool? emailVerified;
  final String? phoneNumber;
  final bool? private;
  final String? displayName;
  final DateTime? created; // Cambiado a DateTime
  final List<String>? categories;
  final List<String>? usersCarer;
  final List<String>? chats;

  final String? email;
  final String? coverPhotoURL;
  final bool? firstSignIn;
  final DateTime? dateBirthday;

  UserAccount({
    this.uid = 'Sin nombre',
    this.photoURL = 'Sin foto',
    this.emailVerified = false,
    this.phoneNumber = 'Sin número',
    this.private = false,
    this.displayName = 'Sin nombre de Usuario',
    this.created, // Fecha arbitraria
    this.categories = const [],
    this.usersCarer = const [],
    this.chats = const [],
    this.email = 'Sin email',
    this.coverPhotoURL =
        'https://i.pinimg.com/736x/e8/9b/a4/e89ba41407fb258daa464ba2e7aa27e2.jpg',
    this.firstSignIn = false,
    this.dateBirthday,
  });

  // Constructor que crea un Usuario a partir de un mapa
  UserAccount.fromMap(Map<String, dynamic> map)
      : uid = map['uid'] ?? 'Sin nombre',
        photoURL = map['photoURL'] ?? 'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg',
        emailVerified = map['emailVerified'] ?? false,
        phoneNumber = map['phoneNumber'] ?? 'Sin número',
        private = map['private'] ?? false,
        displayName = map['displayName'] ?? 'Sin nombre de usuario',
        created = (map['created'] as Timestamp?)?.toDate() ??
            DateTime(2000, 1, 1), // Fecha arbitraria
        categories = List<String>.from(map['categories'] ?? const []),
        usersCarer = List<String>.from(map['usersCarer'] ?? const []),
        chats = List<String>.from(map['chats'] ?? const []),
        email = map['email'] ?? 'Sin email',
        coverPhotoURL = map['coverPhotoURL'] ??
            'https://i.pinimg.com/736x/e8/9b/a4/e89ba41407fb258daa464ba2e7aa27e2.jpg',
        firstSignIn = map['firstSignIn'] ?? false,
        dateBirthday =
            (map['dateBirthday'] as Timestamp?)?.toDate() ?? DateTime(1, 1, 1);
}
