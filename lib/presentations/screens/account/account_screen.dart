import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:recuerda_facil/models/user_account.dart';
import 'package:recuerda_facil/presentations/providers/user_account_provider.dart';
import 'package:recuerda_facil/services/user_services.dart';

import '../../../services/services.dart';
import '../../providers/user_provider.dart';

class AccountScreen extends ConsumerStatefulWidget {
  static const name = 'account_screen';
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> getPrivateUser() async {
    final result = await getPrivate(FirebaseAuth.instance.currentUser!.uid);
    return result;
  }

  // Future<UserAccount?> getUserAccount() async {
  //   final userAccount = await getUser(FirebaseAuth.instance.currentUser!.uid);
  //   return userAccount;
  // }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userAcc = ref.watch(userProviderr(user!.uid));
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    File? imagen_to_upload;
    // final bool private =

    return Scaffold(
      body: Stack(
        children: [
          //container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.grey, // color por defecto si no hay imagen
                image: DecorationImage(
                  image: NetworkImage(userAcc.when(
                    data: (data) {
                      return data!.coverPhotoURL.toString();
                    },
                    error: (error, stackTrace) {
                      return "errror";
                    },
                    loading: () {
                      return "loading";
                    },
                  )),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Puedes añadir otros widgets aquí si es necesario

                  // Icono de cámara en la esquina
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: InkWell(
                      onTap: () async {
                        final imagen = await getImage();
                        imagen_to_upload = File(imagen!.path);

                        await uploadCoverPhoto(user.uid, imagen_to_upload!);
                      },
                      child: Icon(
                        Icons.camera_alt,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //arrow back
          Positioned(
              top: 20,
              left: 0,
              child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back))),

          //name
          Positioned(
              top: size.width * 0.63,
              left: 10,
              child: Text(
                userAcc.when(
                  data: (data) {
                    return data!.displayName.toString();
                  },
                  error: (error, stackTrace) {
                    return "errror";
                  },
                  loading: () {
                    return "loading";
                  },
                ),
                style: textStyle.displaySmall,
              )

              // Text(
              //   user!.displayName.toString(),
              //   style: textStyle.displaySmall,
              // ),
              ),
          //image
          Positioned(
            top: size.width * 0.3,
            left: 10,
            child: Container(
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black54, // El color del borde
                    width: 3,
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    final imagen = await getImage();
                    imagen_to_upload = File(imagen!.path);

                    await uploadProfilePhoto(user.uid, imagen_to_upload!);
                  },
                  child: Stack(
                    children: [
                      ClipOval(
                        child: Image.network(
                          userAcc.when(
                            data: (data) {
                              return data!.photoURL.toString();
                            },
                            error: (error, stackTrace) {
                              return "errror";
                            },
                            loading: () {
                              return "loading";
                            },
                          ),
                          width: size.height * 0.15,
                          height: size.height * 0.15,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(
                          Icons.camera_alt, // Icono de cámara
                          // Color del icono
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          // Positioned(
          //   top: size.height * 0.38,
          // right: 0,
          //   left: 0,

          //   child: FutureBuilder<UserAccount>(future:  getUserAccount(), builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const LinearProgressIndicator();
          //     } else if (snapshot.hasError) {
          //       return Text('Error: ${snapshot.error}');
          //     } else if (snapshot.hasData) {
          //       print(snapshot.data);
          //       return Padding(
          //         padding: const EdgeInsets.symmetric(horizontal:15),
          //         child: Column(
          //           children: [
          //             Row(
          //               children: [
          //                 Text("Unido desde:  ${DateFormat('MMMM yyyy').format(snapshot.data!.created)}",style:const TextStyle(fontWeight: FontWeight.bold),),
          //               ],

          //             ),
          //             const Divider()

          //           ],
          //         ),
          //       );
          //     } else {
          //       return const Text('No data');
          //     }

          // },)),

          Positioned(
            top: size.height * 0.35,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                userAcc.when(
                  data: (data) {
                    return "Unido desde:  ${DateFormat('MMMM yyyy').format(data!.created!)}";
                  },
                  error: (error, stackTrace) {
                    return "error";
                  },
                  loading: () {
                    return "loading";
                  },
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       const Text("Cuenta Privada"),
          //       FutureBuilder<UserAccount?>(
          //         future: getUserAccount(),
          //         builder: (context, snapshot) {
          //           if (snapshot.connectionState == ConnectionState.waiting) {
          //             return const CircularProgressIndicator();
          //           } else if (snapshot.hasError) {
          //             return Text('Error: ${snapshot.error}');
          //           } else if (snapshot.hasData) {
          //             print(snapshot.data);
          //             return SwitchWidget(isEnabled: snapshot.data!.private!);
          //           } else {
          //             return const Text('No data');
          //           }
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SwitchWidget extends StatefulWidget {
  final bool isEnabled;

  SwitchWidget({required this.isEnabled});

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool isEnabled;

  @override
  void initState() {
    super.initState();
    isEnabled = widget
        .isEnabled; // Inicializar el estado con el valor obtenido del Future
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isEnabled,
      onChanged: (value) {
        setState(() {
          isEnabled =
              value; // Actualizar el estado cuando el Switch es activado/desactivado
        });
      },
    );
  }
}
