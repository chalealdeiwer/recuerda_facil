import 'package:dio/dio.dart';

class WitAiService {
  final Dio _dio = Dio();

  final String _witApiUrl = 'https://api.wit.ai/message?q=';
  final String _accessToken = 'D6HZSHR4PR5OU6BKWIAIOHOWVBH4F5MU';

  WitAiService();

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final response = await _dio.get(
        '$_witApiUrl$message',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (error) {
      print('Error en la solicitud a la API de Wit.ai: $error');
      return {};
    }
  }

  List<dynamic> processWitResponse(Map<String, dynamic> witResponse) {
    String content = '';
    String dateString = '';

    // Obtener la acción y el contenido del recordatorio
    
      if (witResponse["entities"]
                  ["recuerdafacil_remember:recuerdafacil_remember"] !=
              null &&
          witResponse["entities"]
                  ["recuerdafacil_remember:recuerdafacil_remember"]
              .isNotEmpty) {
        content = witResponse["entities"]
            ["recuerdafacil_remember:recuerdafacil_remember"][0]["value"];
      }else{
        content = "";
      }
      if (witResponse["entities"]["wit\$datetime:datetime"] != null &&
          witResponse["entities"]["wit\$datetime:datetime"].isNotEmpty) {
        dateString = witResponse["entities"]["wit\$datetime:datetime"][0]["value"];
      }
    

    // Parsear la fecha
    DateTime date;
    if (dateString.isNotEmpty) {
      date = DateTime.parse(dateString);
    } else {
      date =
          DateTime(1,1,1,0,0); // Utilizar la fecha actual si no se proporciona una
    }

    // String reminder =
    //     witResponse["entities"]["recuerdafacil_remember:recuerdafacil_remember"][0]["value"];


    // Devolver el recordatorio y la fecha en un array
    return [content, date];
  }
}
