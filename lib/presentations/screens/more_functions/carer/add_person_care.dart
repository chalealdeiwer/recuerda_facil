import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:recuerda_facil/services/permissions.dart';
import 'package:recuerda_facil/services/user_services.dart';

class AddPersonCareScreen extends ConsumerStatefulWidget {
  static const name = "add_person_care_screen";
  const AddPersonCareScreen({super.key});

  @override
  ConsumerState<AddPersonCareScreen> createState() => _SharedNotesScreenState();
}

class _SharedNotesScreenState extends ConsumerState<AddPersonCareScreen> {
  String data = FirebaseAuth.instance.currentUser!.uid.toString();
  String qrValue = "";

  void showAlertDialogCustom(String title, String message) async {
    showAlertDialog(context, title, message);
  }

  Future<void> scanQr() async {
    if (await requestCameraPermission()) {
      scannerTrue();
    } else {
      showAlertDialogCustom(
          "Información", "No se concedieron permisos para la Cámara ");
    }
  }

  Future<void> scannerTrue() async {
    try {
      String? cameraScanResult = await scanner.scan();

      if (cameraScanResult != null) {
        if (cameraScanResult.toString() ==
            FirebaseAuth.instance.currentUser!.uid.toString()) {
          showAlertDialogCustom(
              "Información", "No se puede escanear usted mismo");
          setState(() {
            qrValue = "Escaneo fallido";
          });
        } else {
          if (await searchUserUid(cameraScanResult.toString())) {
            setState(() {
              qrValue = cameraScanResult.toString();
            });
            if (await addUserCarer(
                FirebaseAuth.instance.currentUser!.uid, qrValue)) {
              showAlertDialogCustom("Información",
                  "El usuario se ha encontrado y se asigno a personas a cuidar");
              if (mounted) {
                context.push('/carer_list/$qrValue');
              }
            } else {
              showAlertDialogCustom("Información",
                  "El usuario ya se encuentra en sus personas a cuidar");
            }
          } else {
            showAlertDialogCustom(
                "Información", "El usuario NO se ha encontrado");
          }
        }
      } else {
        setState(() {
          qrValue = "Nada Escaneado";
        });
      }
    } catch (e) {
      showAlertDialogCustom(
          "Error", "No se pudo escanear, intenta de nuevo: $e");
    }
  }

  void showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // Cierra el AlertDialog
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.displayName.toString(),
              style: const TextStyle(fontSize: 40),
            ),
            const Divider(),
            const Text(
              "Añada personas a su cuidado, esto le permite tener acceso para crear, editar y eliminar los recordatorios de dichas personas",
              style: TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(),
            ElevatedButton(
                onPressed: () {
                  scanQr();
                },
                child: const Text(
                  "Añada personas",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
            Text(qrValue),
          ],
        ),
      ),
    );
  }
}
