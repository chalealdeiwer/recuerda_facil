import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:recuerda_facil/config/notes/app_notes.dart';
import 'package:recuerda_facil/services/permissions.dart';
import 'package:recuerda_facil/services/user_services.dart';

import '../../providers/notes_provider2.dart';

class SharedNotesScreen extends ConsumerStatefulWidget {
  static const  name="shared_notes_screen";
  const SharedNotesScreen({super.key});

  @override
  ConsumerState<SharedNotesScreen> createState() => _SharedNotesScreenState();
}

class _SharedNotesScreenState extends ConsumerState<SharedNotesScreen> {
  String data = FirebaseAuth.instance.currentUser!.uid.toString();
  String qrValue = "Codigo Qr";

  Future<void> scanQr(noteProvider) async {
    if (await requestCameraPermission()) {
      scannertrue(noteProvider);
    } else {
      showwAlertDialog(
          context, "Información", "No se concedieron permisos para la Cámara ");
    }
  }

  Future<void> scannertrue(noteProvider) async {
    try {
      String? cameraScanResult = await scanner.scan();

      if (cameraScanResult != null) {
        if (cameraScanResult.toString() ==
            FirebaseAuth.instance.currentUser!.uid.toString()) {
          showwAlertDialog(
              context, "Información", "No se puede escanear usted mismo");
          setState(() {
            qrValue = "Escaneo así mismo";
          });
        } else {
          if (await searchUserUid(cameraScanResult.toString())) {
            setState(() {
              qrValue = cameraScanResult.toString();
            });
            await noteProvider.addUserNote(qrValue);
            context.push('/home');
            showwAlertDialog(context, "Información", "El usuario se ha encontrado y se cargaron los recordatorios correctamente");
          }else{
            showwAlertDialog(context, "Información", "El usuario NO se ha econtrado");
          }
        }
      } else {
        setState(() {
          qrValue = "Nada Escaneado";
        });
      }
    } catch (e) {
      print('Error durante el escaneo: $e');
      showwAlertDialog(
          context, "Error", "No se pudo escanear, intenta de nuevo: $e");
    }
  }
  

  void showwAlertDialog(BuildContext context, String title, String content) {
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
    final AppNotes noteProvider = ref.watch(noteNotifierProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40,),
            Text(
              FirebaseAuth.instance.currentUser!.displayName.toString(),
              style: const TextStyle(fontSize: 40),
            ),
            const Text(
              "Comparta sus recordatorios",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Divider(
            ),
            Container(
              color: Colors.white,
              child: Center(child: QrImageView(data: data))),
            dividerorline(),
            ElevatedButton(
                onPressed: () {
                  scanQr(noteProvider);
                },
                child: const Text(
                  "Cargue Recordatorios",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
            Text(qrValue),
          ],
        ),
      ),
    );
  }

  Widget dividerorline() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Divider(
          ),
        ),
        Text(
          "  ó  ",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Divider(
          ),
        )
      ],
    );
  }
}
