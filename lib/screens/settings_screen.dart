import 'package:flutter/material.dart';
import 'package:recuerda_facil/src/widgets/categories.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var text = "Mantén presionado el botón y empieza el reconocimiento de voz";
  var isListening = false;
  stt.SpeechToText speech = stt.SpeechToText();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const  Text("Página de configuración"),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body:  Center(
        child: MyExpansionTile(),
      ));
  }
}
