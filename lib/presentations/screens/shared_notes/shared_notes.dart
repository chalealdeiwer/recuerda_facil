import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:recuerda_facil/services/permissions.dart';
import 'package:recuerda_facil/services/user_services.dart';

import '../../providers/notes_provider.dart';

class SharedNotesScreen extends ConsumerStatefulWidget {
  static const name = "shared_notes_screen";
  const SharedNotesScreen({super.key});

  @override
  ConsumerState<SharedNotesScreen> createState() => _SharedNotesScreenState();
}

class _SharedNotesScreenState extends ConsumerState<SharedNotesScreen> {
  String data = FirebaseAuth.instance.currentUser!.uid.toString();
  String qrValue = "Código Qr";

  Future<void> scanQr(noteProvider) async {
    if (await requestCameraPermission()) {
      scannerTrue(noteProvider);
    } else {
      showAlertDialog(
          "Información", "No se concedieron permisos para la Cámara ");
    }
  }

  Future<void> scannerTrue(noteProvider) async {
    try {
      String? cameraScanResult = await scanner.scan();

      if (cameraScanResult != null) {
        if (cameraScanResult.toString() ==
            FirebaseAuth.instance.currentUser!.uid.toString()) {
          showAlertDialog("Información", "No se puede escanear usted mismo");
          setState(() {
            qrValue = "Escaneo así mismo";
          });
        } else {
          if (await searchUserUid(cameraScanResult.toString())) {
            setState(() {
              qrValue = cameraScanResult.toString();
            });
            await noteProvider.addUserNote(qrValue);

            showAlertDialog("Información",
                "El usuario se ha encontrado y se cargaron los recordatorios correctamente");
            if (mounted) {
              context.push('/home/1');
            }
          } else {
            showAlertDialog("Información", "El usuario NO se ha encontrado");
          }
        }
      } else {
        setState(() {
          qrValue = "Nada Escaneado";
        });
      }
    } catch (e) {
      showAlertDialog("Error", "No se pudo escanear, intenta de nuevo: $e");
    }
  }

  void showAlertDialog(String title, String content) {
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
    final  noteProvider = ref.watch(noteNotifierProvider.notifier);

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
            const Text(
              "Comparta sus recordatorios",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Container(
                color: Colors.white,
                child: Center(child: QrImageView(data: data))),
            dividerOrLine(),
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

  Widget dividerOrLine() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Divider(),
        ),
        Text(
          "  ó  ",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Divider(),
        )
      ],
    );
  }
}
