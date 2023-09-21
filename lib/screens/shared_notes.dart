import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:recuerda_facil/models/note.dart';
import 'package:recuerda_facil/services/notes_service.dart';
import 'package:recuerda_facil/services/permissions.dart';
import 'package:recuerda_facil/services/user_services.dart';

class SharedNotesScreen extends StatefulWidget {
  const SharedNotesScreen({super.key});

  @override
  State<SharedNotesScreen> createState() => _SharedNotesScreenState();
}

class _SharedNotesScreenState extends State<SharedNotesScreen> {
  String data = FirebaseAuth.instance.currentUser!.uid.toString();
  String qrValue = "Codigo Qr";
  List<Note> notas = [];

  Future<void> scanQr() async {
    if (await requestCameraPermission()) {
      scannertrue();
    } else {
      showwAlertDialog(
          context, "Información", "No se concedieron permisos para la Camara ");
    }
  }

  // Future<void> scannertrue() async {

  //   String? cameraScanResult = await scanner.scan();
  //   print(cameraScanResult.toString()+ "aqui");
  //   if (cameraScanResult != null) {
  //     if (cameraScanResult.toString() ==
  //         FirebaseAuth.instance.currentUser!.uid.toString()) {
  //           showwAlertDialog(context, "Información", "No se puede escanear usted mismo");
  //           setState(() {
  //             qrValue="Escaneo asi mimso";
  //           });

  //     } else {
  //       setState(() {
  //         qrValue = cameraScanResult.toString();
  //       });

  //       await addUserNote(qrValue);
  //       Navigator.of(context).pushNamed('/home');
  //     }
  //   } else {
  //     setState(() {
  //       qrValue = "Nada Escaneado";
  //     });
  //   }
  // }
  Future<void> scannertrue() async {
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
            await addUserNote(qrValue);
            Navigator.of(context).pushNamed('/home');
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
                Navigator.of(context).pop(); // Cierra el AlertDialog
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40,),
          Text(
            FirebaseAuth.instance.currentUser!.displayName.toString(),
            style: const TextStyle(fontSize: 40),
          ),
          const Text(
            "Comparta sus recordatorios",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Divider(
            color: Colors.black,
          ),
          Container(
            color: Colors.white,
            child: Center(child: QrImageView(data: data))),
          dividerorline(),
          ElevatedButton(
              onPressed: () {
                scanQr();
              },
              child: const Text(
                "Cargue Recordatorios",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
          Text(qrValue),
        ],
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
            color: Colors.black,
          ),
        ),
        Text(
          "  ó  ",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Divider(
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
