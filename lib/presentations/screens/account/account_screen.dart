import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          height: size.height,
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
                  )),

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
                  )),
              //image
              Positioned(
                top: size.width * 0.3,
                left: size.width / 2 - size.width * 0.17,
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
              Positioned(
                  top: size.height * 0.41,
                  left: 0,
                  right: 0,
                  child: const Divider()),
              Positioned(
                top: size.height * 0.43,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Detalles:",
                    style: textStyle.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                  top: size.height * 0.48,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Nombre: ", style: textStyle.titleLarge),
                            Text(
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
                              style: textStyle.titleLarge,
                            ),
                            IconButton(
                                onPressed: () {
                                  _showDialogEditionName();
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Correo: ", style: textStyle.titleLarge),
                            Text(
                              userAcc.when(
                                data: (data) {
                                  return data!.email.toString();
                                },
                                error: (error, stackTrace) {
                                  return "error";
                                },
                                loading: () {
                                  return "loading";
                                },
                              ),
                              style: textStyle.titleLarge,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Teléfono: ", style: textStyle.titleLarge),
                            Text(
                              userAcc.when(
                                data: (data) {
                                  return data!.phoneNumber.toString();
                                },
                                error: (error, stackTrace) {
                                  return "error";
                                },
                                loading: () {
                                  return "loading";
                                },
                              ),
                              style: textStyle.titleLarge,
                            ),
                            IconButton(
                                onPressed: () {
                                  _showDialogEditionPhone();
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Fecha cumpleaños: ",
                                style: textStyle.titleMedium),
                            Text(
                              userAcc.when(
                                data: (data) {
                                  DateTime? birthday = data!.dateBirthday;

                                  if (birthday != null &&
                                      birthday.year == 1 &&
                                      birthday.month == 1 &&
                                      birthday.day == 1) {
                                    return "No establecido";
                                  }

                                  String formattedDate = birthday != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(birthday)
                                      : "Fecha no especificada";

                                  return formattedDate;
                                },
                                error: (error, stackTrace) {
                                  return "Error";
                                },
                                loading: () {
                                  return "Cargando";
                                },
                              ),
                              style: textStyle.titleLarge,
                            ),
                            IconButton(
                                onPressed: () {
                                  _showDateEdition();
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                      ],
                    ),
                  )),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(colors.error),
                      ),
                      onPressed: () {
                        _showDeleteAccount();
                      },
                      child: const Text("Borrar cuenta"))),

              Positioned(
                bottom: size.height * 0.05,
                // top: size.height * 0.50,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Cuenta Privada",
                            style: TextStyle(fontSize: 20),
                          ),
                          userAcc.when(
                            data: (data) {
                              return Switch(
                                value: data!.private!,
                                onChanged: (value) async {
                                  await updatePrivate(userUid, value);
                                  if (mounted) {
                                    setState(() {
                                      userAcc.when(
                                        data: (data) {
                                          return value = !value;
                                        },
                                        error: (error, stackTrace) {
                                          return "error";
                                        },
                                        loading: () {
                                          return "loading";
                                        },
                                      );
                                    });
                                  }
                                },
                              );
                            },
                            error: (error, stackTrace) {
                              return const Text("error");
                            },
                            loading: () {
                              return const Text("loading");
                            },
                          ),
                        ],
                      ),
                      userAcc.when(
                        data: (data) {
                          return data!.private!
                              ? const Text(
                                  "Tu cuenta es privada y no se muestra en 'Personas'",
                                  style: TextStyle(fontSize: 18),
                                )
                              : const Text(
                                  "Tu cuenta es pública y se muestra en 'Personas'",
                                  style: TextStyle(fontSize: 18),
                                );
                        },
                        error: (error, stackTrace) {
                          return const Text("error");
                        },
                        loading: () {
                          return const Text("loading");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo de error
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showDialogEditionName() {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Nombre"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nuevo Nombre"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text("Cancelar"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo

                String nuevoNombre = nameController.text.trim();
                if (nuevoNombre.isNotEmpty) {
                  updateNameUser(
                      FirebaseAuth.instance.currentUser!.uid, nuevoNombre);
                } else {
                  _showError("El nombre no puede estar vacío.");
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Borrar cuenta"),
          content: const Text(
            "¿Estás seguro de que quieres borrar tu cuenta?, al borrar tu cuenta se borrarán todas los recordatorios que hayas creado, además de que no podrás recuperarlos, si deseas continuar tendras que ponerte en contacto con el soporte de la aplicación y explicar el motivo.",
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text("Cancelar"),
            ),
            FilledButton(
              onPressed: () {

                Navigator.of(context).pop(); 
                launchUrlService("https://recuerdafacilpp.deiwerchaleal.com/#contacto");
                // Cierra el diálogo
              },
              child: const Text("Continuar"),
            ),
          ],
        );
      },
    );
  }

  void _showDialogEditionPhone() {
    TextEditingController phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Número de Teléfono"),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration:
                const InputDecoration(labelText: "Nuevo Número de Teléfono"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();

                String newPhone = phoneController.text.trim();
                if (newPhone.isNotEmpty && newPhone.length == 10) {
                  if (int.tryParse(newPhone) != null) {
                    updatePhoneUser(
                        FirebaseAuth.instance.currentUser!.uid, newPhone);
                  } else {
                    _showError("Por favor, ingresa un número válido.");
                  }
                } else {
                  _showError(
                      "El número de teléfono debe tener 10 dígitos y no puede estar vacío.");
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showDateEdition() async {
    DateTime selectedDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });

      updateBirthdayUser(FirebaseAuth.instance.currentUser!.uid, selectedDate);
    }
  }
}
