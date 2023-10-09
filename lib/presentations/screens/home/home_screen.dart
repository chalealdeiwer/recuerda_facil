import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/config/notes/app_notes.dart';
import 'package:recuerda_facil/presentations/views/notes/calendar_view.dart';
import 'package:recuerda_facil/presentations/views/notes/home_view.dart';
import 'package:recuerda_facil/presentations/views/notes/more_view.dart';
import 'package:recuerda_facil/presentations/widgets/categories_selector.dart';
import 'package:recuerda_facil/presentations/widgets/clock_home.dart';
import 'package:recuerda_facil/presentations/widgets/side_menu.dart';
import 'package:recuerda_facil/presentations/widgets/widgets.dart';
import 'package:recuerda_facil/services/permissions.dart';
import 'package:recuerda_facil/presentations/widgets/modal_new_note.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../providers/providers.dart';

// ignore: must_be_immutable
class HomeScreen extends ConsumerStatefulWidget {
  static const name = "home_Screen";
  HomeScreen({super.key, required this.pageIndex});
  // var text = "Mantén presionado el botón y empieza el reconocimiento de voz";
  // var isListening = false;
  stt.SpeechToText speech = stt.SpeechToText();

  int pageIndex;

  final List<Widget> viewRoutes = [
    const MoreView(),

    const HomeView(),

    const CalendarView(),

    // HomeView(isListening, text),
  ];

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final isListeningProv = ref.watch(isListeningProvider);
    final textProv = ref.watch(textProvider);
    final user = ref.watch(userProvider);
    final categoy = ref.watch(categoryProvider);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final AppNotes noteProvider = ref.watch(noteNotifierProvider);
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final customBack = ref.watch(customBackground);
    final opacity = ref.watch(opacityProvider);
    final bottomVisibility = ref.watch(bottomVisibilityProvider);
    final buttonMicrophone = ref.watch(buttonMicrophoneVisibilityProvider);
    final buttonNewNote = ref.watch(buttonNewNoteVisibilityProvider);
    final buttonAction = ref.watch(buttonActionVisibilityProvider);
    final ttsButtonsScreen=ref.watch(ttsButtonsScreenProvider);
    final openMenu = ref.watch(openMenuProvider);
    String viewRouteSpeechText = "";
    PageController _pageController = PageController(
      initialPage: widget.pageIndex,
      keepPage: true,
    );

    // final noteProvider = Provider.of<NoteProvider>(context);
    return WillPopScope(
        onWillPop: () async {
          // Mostrar un diálogo de confirmación antes de salir de la aplicación
          bool exitConfirmed = await showDialog(
            barrierDismissible: false,
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
            extendBodyBehindAppBar: true,
            extendBody: true,
            // backgroundColor: colors.primary,
            key: scaffoldKey,
            drawer: SideMenu(scaffoldKey: scaffoldKey),
            body: Stack(
              children: [
                //background
                if (customBack)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://images.unsplash.com/photo-1537824598505-99ee03483384?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8NXx8fGVufDB8fHx8fA%3D%3D&w=1000&q=80'), // Cambia la URL por la de tu imagen
                            fit: BoxFit
                                .cover, // Esto hará que la imagen cubra toda la pantalla
                          ),
                        ),
                      ),
                    ),
                  ),
                // IndexedStack(
                //     index: widget.pageIndex, children: widget.viewRoutes),

                PageView(
                  controller: _pageController,
                  children: widget.viewRoutes,
                  onPageChanged: (value) {
                    if(ttsButtonsScreen){
                    if (widget.viewRoutes[value].toString() == "CalendarView") {
                      print("1");
                      viewRouteSpeechText = "Pantalla, calendario";
                    } else if (widget.viewRoutes[value].toString() == "HomeView") {
                      print("2");
                      viewRouteSpeechText = "Pantalla, Mi día";
                    } else if (widget.viewRoutes[value].toString() == "MoreView") {
                      print("3");
                      viewRouteSpeechText = "Pantalla, más recursos";
                    }
                    _speak(viewRouteSpeechText);
                  }
                    widget.pageIndex = value;

                  
                  }
                )
              ],
            ),
            bottomNavigationBar: bottomVisibility
                ? CustomBottomNavigation(currentIndex: widget.pageIndex)
                : null,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (buttonAction)
                  Column(
                    children: [
                      if (openMenu)
                        Builder(
                          builder: (context) => FadeInUp(
                            duration: const Duration(milliseconds: 500),
                            child: FloatingActionButton(
                              heroTag: null,
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              backgroundColor: colors.primary.withOpacity(0.8),
                              child: Icon(
                                Icons.menu,
                                color:
                                    isDarkMode ? Colors.black45 : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (openMenu && !buttonNewNote)
                        FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              showNewNote(context, categoy);
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          ref
                              .read(openMenuProvider.notifier)
                              .update((openMenu) => !openMenu);
                        },
                        child: openMenu
                            ? const Icon(Icons.arrow_downward)
                            : const Icon(Icons.arrow_upward),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                if (buttonMicrophone)
                  AvatarGlow(
                    endRadius: 70.0,
                    animate: isListeningProv,
                    duration: const Duration(milliseconds: 2000),
                    glowColor: Colors.green,
                    repeat: true,
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    showTwoGlows: true,
                    child: GestureDetector(
                      onTapDown: (details) async {
                        if (await requestMicrophone() == true) {
                          if (!isListeningProv) {
                            bool available = await widget.speech.initialize();
                            if (available) {
                              ref
                                  .read(isListeningProvider.notifier)
                                  .update((isListening) => !isListening);
                              widget.speech.listen(
                                onResult: (result) {
                                  ref.read(textProvider.notifier).update(
                                      (state) => result.recognizedWords);
                                },
                              );
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
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                content:
                                    const Text("No se concedieron permisos"),
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
                        ref
                            .read(isListeningProvider.notifier)
                            .update((isListening) => !isListening);

                        widget.speech.stop();
                        await noteProvider
                            .addNote(
                                textProv,
                                "",
                                user!.uid,
                                DateTime.now(),
                                false,
                                categoy,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          isListeningProv ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (buttonNewNote)
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
              const Text("Añadir nuevo recordatorio"),
              if (category != "Sin Categoría" && category != "Todos")
                Text(
                  "en: $category",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
            ],
          ),
          content: const ModalNewNote(),

        );
      });
}
