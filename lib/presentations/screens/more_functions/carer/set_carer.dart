import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class SetCarer extends StatefulWidget {
  static const  name="set_carer";
  const SetCarer({super.key});

  @override
  State<SetCarer> createState() => _SharedNotesScreenState();
}

class _SharedNotesScreenState extends State<SetCarer> {
  String data = FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  Widget build(BuildContext context) {

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
              "Asigne personas que lo cuiden ",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text("pida el favor a su cuidador que escanee este código QR", style: TextStyle(fontSize: 20,),textAlign: TextAlign.center,),
            const Divider(
            ),
            Container(
              color: Colors.white,
              child: Center(child: QrImageView(data: data))),
          ],
        ),
      ),
    );
  }

  
}
