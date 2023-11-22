import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:recuerda_facil/features/auth/presentation/providers/providers_auth.dart';
import 'package:recuerda_facil/presentations/providers/user_account_provider.dart';

import '../../../services/services.dart';

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

  

  @override
  Widget build(BuildContext context) {
    final userUid = ref.watch(authProvider).user!.uid;
    
    final userAcc = ref.watch(userProviderr(userUid!));
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    File? imagenToUpload;
    // final bool private =

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1000,
          child: Stack(
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
                          return "error";
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
                      
        
                      // Icono de cámara en la esquina
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: InkWell(
                          onTap: () async {
                            final imagen = await getImage();
                            if (imagen == null) return;
                            imagenToUpload = File(imagen.path);
        
                            await uploadCoverPhoto(userUid, imagenToUpload!);
                          },
                          child: const Icon(
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
        
              //display name
              Positioned(
                  top: size.width * 0.63,
                  left: 10,
                  child: Text(
                    userAcc.when(
                      data: (data) {
                        return data!.displayName.toString();
                      },
                      error: (error, stackTrace) {
                        return "error";
                      },
                      loading: () {
                        return "loading";
                      },
                    ),
                    style: textStyle.displaySmall,
                  )


                  ),
                  
                  //email
                  Positioned(
                  top: size.width * 0.73,
                  left: 10,
                  child: Text(
                    userAcc.when(
                      data: (data) {
                        return "(${data!.email.toString()})";
                      },
                      error: (error, stackTrace) {
                        return "error";
                      },
                      loading: () {
                        return "loading";
                      },
                    ),
                    style: textStyle.titleMedium,
                  )

                  ),
              //image
              Positioned(
                top: size.width * 0.3,
                left: size.width/2-size.width*0.17,
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
                        if (imagen == null) return;
                        imagenToUpload = File(imagen!.path);
        
                        await uploadProfilePhoto(userUid, imagenToUpload!);
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
                                  return "error";
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
              Positioned(
                top: size.height * 0.36,
                left: 0,
                right: 0,
                child: const Divider()),
              Positioned(
                top: size.height * 0.37,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    userAcc.when(
                      data: (data) {
                        return "Desde:  ${DateFormat('MMMM yyyy').format(data!.created!)}";
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
        ),
      ),
    );
  }
}

class SwitchWidget extends StatefulWidget {
  final bool isEnabled;

  const SwitchWidget({super.key, required this.isEnabled});

  @override
  SwitchWidgetState createState() => SwitchWidgetState();
}

class SwitchWidgetState extends State<SwitchWidget> {
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
