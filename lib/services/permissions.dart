import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission() async {
  final status = await Permission.camera.request();
  if (status.isGranted) {
    return true;
    // El permiso de la cámara se otorgó, ahora puedes abrir el escáner QR
  } else {
    // El usuario negó el permiso, puedes mostrar un mensaje de error o solicitar el permiso nuevamente
  }return false;
}

Future<bool> requestMicrophone() async {
  final status = await Permission.microphone.request();
  if (status.isGranted) {
    return true;
    // El permiso de la cámara se otorgó, ahora puedes abrir el escáner QR
  } else {
    // El usuario negó el permiso, puedes mostrar un mensaje de error o solicitar el permiso nuevamente
  }return false;
}