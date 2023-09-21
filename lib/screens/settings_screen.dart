import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recuerda_facil/providers/notes_provider.dart';
import 'package:recuerda_facil/services/permissions.dart';
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
    final noteProvider = Provider.of<NoteProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Página de configuración"),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Text("Hola"),
      ));
  }
}
