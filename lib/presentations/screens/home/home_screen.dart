import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/config/notes/app_notes.dart';
import 'package:recuerda_facil/presentations/widgets/categories_selector.dart';
import 'package:recuerda_facil/presentations/widgets/clock_home.dart';
import 'package:recuerda_facil/presentations/widgets/side_menu.dart';
import 'package:recuerda_facil/services/permissions.dart';
import 'package:recuerda_facil/presentations/widgets/modal_new_note.dart';
import 'package:recuerda_facil/presentations/widgets/stream_list.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../providers/providers.dart';

// ignore: must_be_immutable
class HomeScreen extends ConsumerStatefulWidget {
  static const name = "home_Screen";
  HomeScreen({super.key});
  var text = "Mantén presionado el botón y empieza el reconocimiento de voz";
  var isListening = false;
  stt.SpeechToText speech = stt.SpeechToText();

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final categoy = ref.watch(categoryProvider);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final AppNotes noteProvider = ref.watch(noteNotifierProvider);
    final colors = Theme.of(context).colorScheme;

    // final noteProvider = Provider.of<NoteProvider>(context);
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
                    ),
                  ),
                  FilledButton(
                    onPressed: () => SystemNavigator.pop(),
                    // Navigator.of(context).pop(true),
                    child: const Text(
                      'Salir',
                    ),
                  ),
                ],
              );
            },
          );
          return exitConfirmed ? true : false;
          // Si el usuario cancela el diálogo, no sale de la aplicación.
        },
        child: Scaffold(
            key: scaffoldKey,

            // backgroundColor: Vx.hexToColor("#e8eddb"),
            appBar: AppBar(
              // backgroundColor: Vx.hexToColor("#e8eddb"),
              // title: Text(user != null? user.displayName.toString(): "Hola"),
              title: const Text("Recuerda Fácil"),
              actions: [
                IconButton(
                    onPressed: () {
                      showNewNote(context, categoy);
                    },
                    icon: const Icon(Icons.add)),
                IconButton(
                    onPressed: () {
                      ref.read(themeNotifierProvider.notifier).toogleDarkMode();

                      ref
                          .read(isDarkmodeProvider.notifier)
                          .update((darkmode) => !darkmode);
                    },
                    icon: isDarkMode
                        ? const Icon(Icons.light_mode_outlined)
                        : const Icon(Icons.dark_mode_outlined)),
                TextButton(
                    onPressed: () {
                      context.push('/account');
                    },
                    child: (isDarkMode)
                        ? Image.asset(
                            'assets/images/logodark.png',
                            height: 50,
                          )
                        : Image.asset(
                            'assets/images/logo.png',
                            height: 50,
                          )),
              ],
            ),
            drawer: SideMenu(scaffoldKey: scaffoldKey),
            body: Column(
              children: [
                const SizedBox(
                  height: 2,
                ),

                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.050,
                    child: CategorySelector()),
                const SizedBox(
                  height: 2,
                ),

                ClockWidget(),
                // SizedBox(
                //     height: MediaQuery.of(context).size.height * 0.75,
                //     child: const StreamListWidget()),
                const SizedBox(
                  height: 5,
                ),
                Expanded(child: StreamListWidget()),
                //container
                if (widget.isListening)
                  SizedBox(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        widget.text,
                        style: TextStyle(
                            fontSize: 24,
                            color: widget.isListening
                                ? colors.primary
                                : colors.secondary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),
            // bottomNavigationBar: const BottonBar(),

            floatingActionButton: Column(
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
                      if (await requestMicrophone() == true) {
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
                                    context.pop(); // Cierra el AlertDialog
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
                      await noteProvider
                          .addNote(
                              widget.text,
                              "",
                              user!.uid,
                              DateTime.now(),
                              "pendiente",
                              "Sin Categoría",
                              DateTime.now(),
                              Icons.alarm.codePoint.toString())
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(milliseconds: 2000),
                            action: SnackBarAction(
                                textColor: Colors.black,
                                label: "¡Ok!",
                                onPressed: () {}),
                            backgroundColor: Colors.green[200],
                            content: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "¡Recordatorio agregado correctamente!",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(Icons.add_alert_sharp)
                              ],
                            )));
                      });
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
                  glowColor: colors.secondary,
                  repeat: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  showTwoGlows: true,
                  child: FloatingActionButton(
                    onPressed: () {
                      showNewNote(context, categoy);
                    },
                    backgroundColor: colors.primary.withOpacity(0.8),
                    child: Icon(
                      Icons.add,
                      color: isDarkMode ? Colors.black45 : Colors.white,
                    ),
                  ),
                ),
              ],
            )));
  }
}

void showNewNote(BuildContext context, category) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Wrap(
            children: [
              const Text("Añadir nuevo recordatorio en:"),
              Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          content: const ModalNewNote(),
        );
      });
}

class _CategoriesWidget extends ConsumerStatefulWidget {
  const _CategoriesWidget();

  @override
  ConsumerState<_CategoriesWidget> createState() => _CategoriesWidgetState();
}

enum Categories {
  sin_categoria,
  salud,
  medicamentos,
  trabajo,
  cumpleanos,
  aniversarios,
  personal
}

class _CategoriesWidgetState extends ConsumerState<_CategoriesWidget> {
  Categories selectCategorie = Categories.sin_categoria;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final AppNotes noteProvider = ref.watch(noteNotifierProvider);

    bool _isExpanded = false;

    return ExpansionTile(
      initiallyExpanded: _isExpanded,
      onExpansionChanged: (bool expanding) => setState(() {
        print(expanding);
        _isExpanded = expanding;
      }),

      title: StreamBuilder<int>(
        stream: noteProvider.getNotesLengthStream(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notesLength = snapshot.data;
            return Text(
              'Todos los recordatorios $notesLength',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            );
          } else {
            return const Text(
                'Cargando...'); // Puedes mostrar un mensaje de carga mientras se obtiene la longitud.
          }
        },
      ),

      // title: const Text("Todos los Recordatorios",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
      subtitle: Text(selectCategorie.name.toUpperCase()),

      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = false;
              print(_isExpanded);
            });
          },
          child: RadioListTile(
            title: const Text("Sin Categoría"),
            subtitle: const Text("Recordatorios sin categoría"),
            value: Categories.sin_categoria,
            groupValue: selectCategorie,
            onChanged: (value) {
              setState(() {
                selectCategorie = Categories.sin_categoria;
                _isExpanded = false;
                print(_isExpanded);
              });
            },
          ),
        ),
        RadioListTile(
          title: const Text("Salud"),
          subtitle: const Text("Categoría Salud"),
          value: Categories.salud,
          groupValue: selectCategorie,
          onChanged: (value) {
            setState(() {
              _isExpanded = false;
              selectCategorie = Categories.salud;
            });
          },
        ),
        RadioListTile(
          title: const Text("Medicamentos"),
          subtitle: const Text("Categoría Medicamentos"),
          value: Categories.medicamentos,
          groupValue: selectCategorie,
          onChanged: (value) {
            setState(() {
              _isExpanded = false;
              selectCategorie = Categories.medicamentos;
            });
          },
        ),
        RadioListTile(
          title: const Text("Trabajo"),
          subtitle: const Text("Categoría Trabajo"),
          value: Categories.trabajo,
          groupValue: selectCategorie,
          onChanged: (value) {
            setState(() {
              _isExpanded = false;
              selectCategorie = Categories.trabajo;
            });
          },
        ),
        RadioListTile(
          title: const Text("Cumpleaños"),
          subtitle: const Text("Categoría Cumpleaños"),
          value: Categories.cumpleanos,
          groupValue: selectCategorie,
          onChanged: (value) {
            setState(() {
              _isExpanded = false;
              selectCategorie = Categories.cumpleanos;
            });
          },
        ),
        RadioListTile(
          title: const Text("Aniversario"),
          subtitle: const Text("Categoría Aniversarios"),
          value: Categories.aniversarios,
          groupValue: selectCategorie,
          onChanged: (value) {
            setState(() {
              _isExpanded = false;
              selectCategorie = Categories.aniversarios;
            });
          },
        ),
        RadioListTile(
          title: const Text("Personal"),
          subtitle: const Text("Categoría Personal"),
          value: Categories.personal,
          groupValue: selectCategorie,
          onChanged: (value) {
            setState(() {
              _isExpanded = false;
              selectCategorie = Categories.personal;
            });
          },
        ),
      ],
    );
  }
}
