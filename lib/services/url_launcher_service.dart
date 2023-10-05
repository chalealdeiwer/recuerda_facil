import 'package:url_launcher/url_launcher.dart';
  Future<void> launchEmailPrivacy(String toEmail) async {
  final Uri url=Uri.parse("mailto:$toEmail?subject=Consulta Privacidad&body=Cordial Saludo, quisiera obtener más información acerca de la política de privacidad...%20");
  if(!await launchUrl(url)){
    throw 'No se pudo lanzar $url';
  }
}
// Future<void> _launchUrl() async {
//   final Uri _url = Uri.parse('https://flutter.dev');
//   if (!await launchUrl(_url)) {
//     throw Exception('Could not launch $_url');
//   }
// }
Future<void> launchEmailSupport(String toEmail) async {
  final Uri url=Uri.parse("mailto:$toEmail?subject=Contacto Soporte&body=Cordial Saludo, (describe brevemente el motivo del contacto, adjunta capturas de pantalla de ser necesario)...%20");
  if(!await launchUrl(url)){
    throw 'No se pudo lanzar $url';
  }
}

Future<void> launchPhone(String phoneNumber) async {
  final Uri url=Uri.parse("tel:$phoneNumber");
  if(!await launchUrl(url)){
    throw 'No se pudo lanzar $url';
  }
}
Future<void> launchWhatsApp(String phone,String message) async {
  final Uri url=Uri.parse("https://wa.me/$phone?text=$message");
  if(!await launchUrl(url)){
    throw 'No se pudo lanzar $url';
  }
}