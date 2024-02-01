
import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/features/auth/presentation/providers/providers_auth.dart';
import 'package:recuerda_facil/presentations/views/notes/calendar_view.dart';
import 'package:recuerda_facil/presentations/views/notes/home_view.dart';
import 'package:recuerda_facil/presentations/views/notes/more_view.dart';
import 'package:recuerda_facil/presentations/widgets/widgets.dart';
import 'package:recuerda_facil/services/permissions.dart';
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

  void notPermissions() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Información",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    final isListeningProv = ref.watch(isListeningProvider);
    final textProv = ref.watch(textProvider);
    final user = ref.watch(authProvider).user;
    final category = ref.watch(categoryProvider);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final noteProvider = ref.watch(noteNotifierProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    final customBack = ref.watch(preferencesProvider).customBackground;
    final opacity = ref.watch(preferencesProvider).opacity;
    final bottomVisibility = ref.watch(preferencesProvider).bottomVisibility;
    final buttonMicrophone =
        ref.watch(preferencesProvider).buttonMicrophoneVisibility;
    final buttonNewNote =
        ref.watch(preferencesProvider).buttonNewNoteVisibility;
    final buttonAction = ref.watch(preferencesProvider).buttonActionVisibility;
    final ttsButtonsScreen = ref.watch(ttsButtonsScreenProvider);
    final openMenu = ref.watch(openMenuProvider);
    final showButton = ref.watch(buttonPageChangeProvider);
    final backgroundImage=ref.watch(preferencesProvider).background; 
    String viewRouteSpeechText = "";
    PageController pageController = PageController(
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
                  '¿Está seguro de que quiere salir de la aplicación?',
                  style: TextStyle(fontSize: 22),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  FilledButton(
                    onPressed: () => SystemNavigator.pop(),
                    // Navigator.of(context).pop(true),
                    child: const Text(
                      'Salir',
                      style: TextStyle(fontSize: 18),
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
                      child: Image(
                        image: backgroundImage.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                // IndexedStack(
                //     index: widget.pageIndex, children: widget.viewRoutes),

                PageView(
                    controller: pageController,
                    children: widget.viewRoutes,
                    onPageChanged: (value) {
                      if (value == 1) {
                        ref
                            .read(buttonPageChangeProvider.notifier)
                            .update((showButton) => true);
                      } else {
                        ref
                            .read(buttonPageChangeProvider.notifier)
                            .update((showButton) => false);
                      }

                      if (ttsButtonsScreen) {
                        if (widget.viewRoutes[value].toString() ==
                            "CalendarView") {
                          viewRouteSpeechText = "Pantalla, calendario";
                        } else if (widget.viewRoutes[value].toString() ==
                            "HomeView") {
                          viewRouteSpeechText = "Pantalla, Mi día";
                        } else if (widget.viewRoutes[value].toString() ==
                            "MoreView") {
                          viewRouteSpeechText = "Pantalla, más recursos";
                        }
                        _speak(viewRouteSpeechText);
                      }
                      widget.pageIndex = value;
                    })
              ],
            ),
            bottomNavigationBar: bottomVisibility
                ? CustomBottomNavigation(currentIndex: widget.pageIndex)
                : null,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (buttonAction && showButton)
                  Column(
                    children: [
                      if (openMenu && showButton)
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
                      if (openMenu && !buttonNewNote && showButton)
                        FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              showNewNote(context, category, user!.uid);
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
                if (buttonMicrophone && showButton)
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
                              // print(
                              //     "The user has denied the use of speech recognition.");
                            }
                            // some time later...
                          }
                        } else {
                          notPermissions();
                          return;
                        }
                      },
                      onTapUp: (details) async {
                        if (isListeningProv == false) return;
                        ref
                            .read(isListeningProvider.notifier)
                            .update((isListening) => !isListening);

                        widget.speech.stop();
                        if (textProv == "") return;
                        if (textProv == "cancelar") return;
                        if (textProv ==
                            "Mantén presionado el botón para iniciar el reconocimiento de voz") {
                          return;
                        }
                        await noteProvider
                            .addNote(
                                textProv,
                                "",
                                user!.uid!,
                                DateTime.now(),
                                false,
                                category,
                                DateTime(1, 1, 1, 0, 0),
                                DateTime(1, 1, 1, 0, 0),
                                Icons.alarm.codePoint.toString())
                            .then((value) {
                          ref.read(textProvider.notifier).update((state) =>
                              "Mantén presionado el botón para iniciar el reconocimiento de voz");
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
                                    "¡Recordatorio agregado!",
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
                if (buttonNewNote && showButton)
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
                        showNewNote(context, category, user!.uid);
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

void showNewNote(BuildContext context, category, user) {
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
          content: ModalNewNote(user: user),
        );
      });
}
