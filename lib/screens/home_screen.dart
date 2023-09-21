import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:recuerda_facil/providers/notes_provider.dart';
import 'package:recuerda_facil/screens/login_screen.dart';
import 'package:recuerda_facil/services/permissions.dart';
import 'package:recuerda_facil/src/widgets/customDrawer/drawer.dart';
import 'package:recuerda_facil/src/widgets/modal_new_note.dart';
import 'package:recuerda_facil/src/widgets/stream_list.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  var text = "Mantén presionado el botón y empieza el reconocimiento de voz";
  var isListening = false;
  stt.SpeechToText speech = stt.SpeechToText();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    return WillPopScope(
        onWillPop: () async {
          // Mostrar un diálogo de confirmación antes de salir de la aplicación
          bool exitConfirmed = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('¿Salir?'),
                content: const Text(
                    '¿Estás seguro de que quieres salir de la aplicación?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    // Navigator.of(context).pop(true),
                    child: const Text(
                      'Salir',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              );
            },
          );
          return exitConfirmed ??
              false; // Si el usuario cancela el diálogo, no sale de la aplicación.
        },
        child: Scaffold(
          
            // backgroundColor: Vx.hexToColor("#e8eddb"),
            appBar: AppBar(
              // backgroundColor: Vx.hexToColor("#e8eddb"),
              title: Text(
                FirebaseAuth.instance.currentUser!.displayName.toString(),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      showNewNote(context);

                      //   // showTimePicker(context: context, initialTime: TimeOfDay(hour: DateTime.now().day, minute: DateTime.now().minute));
                    },
                    icon: const Icon(Icons.add)),
                IconButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance.terminate();
                      GoogleSignIn().signOut();

                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false);
                    },
                    icon: const Icon(Icons.exit_to_app))
              ],
            ),
            drawer: MyDrawer(),
            //aqui va de nuevo con provider
            // body: Text("Hola"),
            body: Column(
              children: [
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: StreamBuilder<int>(
                    stream: noteProvider.getNotesLengthStream(
                        FirebaseAuth.instance.currentUser!.uid.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final notesLength = snapshot.data;
                        return Text(
                          'Recordatorios: $notesLength',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        );
                      } else {
                        return Text(
                            'Cargando...'); // Puedes mostrar un mensaje de carga mientras se obtiene la longitud.
                      }
                    },
                  ),
                ),
                Expanded(child: StreamListWidget()),
                Container(
                  
                  height: 250,
                  child: Padding(

                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      widget.text,
                      style: TextStyle(
                          fontSize: 24,
                          color: widget.isListening
                              ? Colors.black87
                              : Colors.black54,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
            // bottomNavigationBar: const BottonBar(),

            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AvatarGlow(
                  endRadius: 70.0,
                  animate: widget.isListening,
                  duration: const Duration(milliseconds: 2000),
                  glowColor: Colors.green,
                  repeat: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  showTwoGlows: true,
                  child: GestureDetector(
                    onTapDown: (details) async {
                      if (await requestMicrophone()==true) {
                        if (!widget.isListening) {
                          bool available = await widget.speech.initialize();
                          if (available) {
                            setState(() {
                              widget.isListening = true;
                              widget.speech.listen(
                                onResult: (result) {
                                  setState(() {
                                    widget.text = result.recognizedWords;
                                  });
                                },
                              );
                            });
                          } else {
                            print(
                                "The user has denied the use of speech recognition.");
                          }
                          // some time later...
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Información",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              content: const Text("No se concedieron permisos"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cierra el AlertDialog
                                  },
                                  child: const Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    onTapUp: (details) async {
                      setState(() {
                        widget.isListening = false;
                      });
                      widget.speech.stop();
                      await noteProvider.addNote(
                          widget.text,
                          "",
                          FirebaseAuth.instance.currentUser!.uid.toString(),
                          DateTime.now(),
                          "pendiente",
                          "Sin Categoría",
                          DateTime.now());

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(milliseconds: 1100),
                              backgroundColor: Colors.green[200],
                              content: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "¡Recordatorio agregado correctamente!",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Icon(Icons.add_alert_sharp)
                                ],
                              )
                              ));

                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 35,
                      child: Icon(
                        widget.isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                AvatarGlow(
                  endRadius: 70.0,
                  animate: true,
                  duration: const Duration(milliseconds: 2000),
                  glowColor: Colors.green,
                  repeat: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  showTwoGlows: true,
                  child: FloatingActionButton(
                    onPressed: () {
                      showNewNote(context);
                    },
                    backgroundColor: Colors.blueAccent,
                    child: Icon(
                      
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )));
  }
}

void showNewNote(BuildContext context) {
  showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Añadir Nuevo Recordatorio"),
          content: ModalNewNote(),
        );
      });
}
