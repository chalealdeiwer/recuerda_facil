import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:recuerda_facil/config/notes/app_notes.dart';

import '../providers/providers.dart';

class StreamListWidget extends ConsumerStatefulWidget {
  final bool done;
  const StreamListWidget({required this.done, super.key});

  @override
  ConsumerState<StreamListWidget> createState() => _StreamListWidgetState();
}

class _StreamListWidgetState extends ConsumerState<StreamListWidget> {
  late FlutterTts flutterTts; // Declara una variable para FlutterTts
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
    final category = ref.watch(categoryProvider.notifier).state;
    final user = ref.watch(userProvider);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final AppNotes noteProvider = ref.read(noteNotifierProvider);
    final ttsTitle = ref.watch(ttsTitleProvider);
    final ttsContent = ref.watch(ttsContentProvider);
    final ttsCategory = ref.watch(ttsCategoryProvider);
    final textToSpeech = ref.watch(onTestToSpeechProvider);
    //recordatorios finalizados
    if (!widget.done) {
      return user != null
          ? StreamBuilder<List>(
              stream:
                  noteProvider.getNotesStream(user.uid.toString(), category),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final notes = snapshot.data;
                  final notes2 = notes!
                      .where((element) => element.stateDone == true)
                      .toList();

                  if (notes2.isEmpty && notes.isEmpty) {
                    return const SliverToBoxAdapter(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Agrega recordatorios pulsando el botón +",
                        style: TextStyle(fontSize: 20),
                      ),
                    ));
                  }
                  if (notes2.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Aún Tienes recordatorios pendientes",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }

                  return SliverList.builder(
                    addAutomaticKeepAlives: true,
                    itemCount: notes2.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: (direction) async {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            action: SnackBarAction(
                                label: "¡Ok!",
                                textColor: Colors.black,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                }),
                            duration: const Duration(milliseconds: 2000),
                            content: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.delete_forever),
                                Text(
                                  "¡Recordatorio Eliminado!",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.red[200],
                          ));
                          noteProvider.deleteNote(notes2[index].key);
                          ref.refresh(remindersProvider(user.uid));

                          notes2.removeAt(index);
                        },
                        confirmDismiss: (direction) async {
                          bool result = true;
                          try {
                            result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: SingleChildScrollView(
                                      child: AlertDialog(
                                        title: Text(
                                            "¿Está seguro de que quiere eliminar ${snapshot.data?[index].title} ?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                return Navigator.pop(
                                                    context, false);
                                              },
                                              child: const Text("Cancelar")),
                                          FilledButton(
                                              onPressed: () {
                                                return Navigator.pop(
                                                    context, true);
                                              },
                                              child: const Text(
                                                  "Si, estoy seguro"))
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            return result;
                          } catch (e) {
                            return false;
                          }
                        },
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red[400],
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.delete, size: 35),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                        key: Key(notes2[index].key),
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 2, top: 2),

                          // padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
                          decoration: BoxDecoration(
                              // color:Theme.of(context).colorScheme.secondary.withOpacity(0.20),
                              color: colors.surfaceVariant.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            leading: Transform.scale(
                              scale: 2,
                              child: Opacity(
                                opacity: 0.7,
                                child: Checkbox(
                                  value: notes2[index].stateDone,
                                  onChanged: (value) async {
                                    if (notes2[index].stateDone == true) {
                                      await noteProvider.updateNoteDateFinish(
                                          notes2[index].key,
                                          DateTime(1, 1, 1, 0, 0));
                                    }
                                    await noteProvider.toggleNoteState(
                                        notes2[index].key, !value!);
                                  },
                                ),
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                            ),
                            title: Text(
                              notes2[index].title,
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 20,
                              ),
                              maxLines: 30,
                            ),
                            subtitle: SizedBox(
                              // width: MediaQuery.of(context).size.width*0.2,
                              height: 80,
                              child: Column(
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      Text(
                                        notes2[index].content,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      if (notes2[index].category != '')
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical:
                                                  4.0), // Ajusta el padding según necesites
                                          decoration: BoxDecoration(
                                            color: colors
                                                .background, // Define el color de fondo
                                            borderRadius: BorderRadius.circular(
                                                20), // Define el borderRadius
                                          ),
                                          child: Text(notes2[index]
                                              .category), // Tu widget Text
                                        ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    children: [
                                      notes2[index].dateFinish !=
                                              DateTime(1, 1, 1, 0, 0)
                                          ? Text(
                                              'Finalizado: ${DateFormat('dd MMM hh:mm a').format(notes2[index].dateFinish)}')
                                          : const Text(""),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onLongPress: () {
                              showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Información Recordatorio"),
                                      content: SizedBox(
                                        height: 300,
                                        width: 500,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Wrap(
                                              alignment: WrapAlignment.start,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              children: [
                                                Text(
                                                    'Creado: ${DateFormat('dd MMM hh:mm a').format(notes2[index].dateCreate)}')
                                              ],
                                            ),
                                            const Text("Recordatorio"),
                                            Text(notes2[index].title),
                                            const Text(
                                              "Descripción",
                                            ),
                                            Text(notes2[index].content),
                                            FilledButton(
                                                onPressed: () async {
                                                  context.pop();
                                                },
                                                child: const Text("Aceptar"))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            onTap: () {
                              String speechText = "";

                              if (ttsTitle && textToSpeech) {
                                speechText +=
                                    "Recordatorio ${notes2[index].title}. ";
                              }

                              if (ttsContent) {
                                if (notes2[index].content.isNotEmpty) {
                                  speechText +=
                                      "Descripción ${notes2[index].content}. ";
                                } else {
                                  speechText += "Sin descripción. ";
                                }
                              }

                              if (ttsCategory) {
                                if (notes2[index].category.isNotEmpty) {
                                  speechText +=
                                      "Categoría ${notes2[index].category}. ";
                                } else {
                                  speechText += "Sin categoría. ";
                                }
                              }

                              if (speechText.isNotEmpty) {
                                _speak(speechText);
                              }
                            },

                            // onTap: () async {

                            //  await Navigator.pushNamed(context, '/edit',arguments: {
                            //     "name": snapshot.data?[index]["name"],
                            //      "uid": snapshot.data?[index]["uid"]
                            //   });
                            //   setState(() {

                            //   });
                            // },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const SliverToBoxAdapter(
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator.adaptive(),
                        Text(
                          "Cargando por favor espere",
                          style: TextStyle(fontSize: 30),
                        )
                      ],
                    )),
                  );
                }
              },
            )
          : SliverToBoxAdapter(
              child: Column(
                children: [
                  isDarkMode
                      ? Image.asset(
                          "assets/images/notnotesdark.png",
                          height: 200,
                        )
                      : Image.asset(
                          "assets/images/notnotes.png",
                          height: 200,
                        ),
                  Center(
                    child: Text(
                      "Aún no hay recordatorios",
                      style: textStyle.titleLarge,
                    ),
                  ),
                ],
              ),
            );
    } else {
      //recordatorios pendientes
      return user != null
          ? StreamBuilder<List>(
              stream:
                  noteProvider.getNotesStream(user.uid.toString(), category),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final notes = snapshot.data;
                  final notes2 = notes!
                      .where((element) => element.stateDone == false)
                      .toList();

                  if (notes2.isEmpty && notes.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          isDarkMode
                              ? Image.asset(
                                  "assets/images/notnotesdark.png",
                                  height: 200,
                                )
                              : Image.asset(
                                  "assets/images/notnotes.png",
                                  height: 200,
                                ),
                          Center(
                            child: Text(
                              "Aún no hay recordatorios",
                              style: textStyle.titleLarge,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (notes2.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "¡Todos los recordatorios realizados!",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }
                  return SliverList.builder(
                    addAutomaticKeepAlives: true,
                    itemCount: notes2.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: (direction) async {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            action: SnackBarAction(
                                label: "¡Ok!",
                                textColor: Colors.black,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                }),
                            duration: const Duration(milliseconds: 2000),
                            content: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.delete_forever),
                                Text(
                                  "¡Recordatorio Eliminado!",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.red[200],
                          ));
                          noteProvider.deleteNote(notes2[index].key);
                          notes2.removeAt(index);
                        },
                        confirmDismiss: (direction) async {
                          bool result = true;
                          try {
                            result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: SingleChildScrollView(
                                      child: AlertDialog(
                                        title: Text(
                                            "¿Está seguro de que quiere eliminar ${snapshot.data?[index].title} ?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                return Navigator.pop(
                                                    context, false);
                                              },
                                              child: const Text("Cancelar")),
                                          FilledButton(
                                              onPressed: () {
                                                return Navigator.pop(
                                                    context, true);
                                              },
                                              child: const Text(
                                                  "Si, estoy seguro"))
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            return result;
                          } catch (e) {
                            return false;
                          }
                        },
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red[400],
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.delete, size: 35),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                        key: Key(notes2[index].key),
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 2, top: 2),

                          // padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
                          decoration: BoxDecoration(
                              // color:Theme.of(context).colorScheme.secondary.withOpacity(0.20),
                              color: colors.surfaceVariant.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Flexible(
                                  child: Icon(
                                    Icons.notifications_active_outlined,
                                    size:
                                        30, // Puedes ajustar este valor según sea necesario
                                  ),
                                ),
                                const Expanded(
                                  child: SizedBox(
                                    height: 20,
                                  ),
                                ),
                                Flexible(
                                  child: Transform.scale(
                                    scale: 2,
                                    child: Checkbox(
                                        value: notes2[index].stateDone,
                                        onChanged: (value) async {
                                          await noteProvider.toggleNoteState(
                                              notes2[index].key, !value!);

                                          if (notes2[index].stateDone ==
                                              false) {
                                            await noteProvider
                                                .updateNoteDateFinish(
                                                    notes2[index].key,
                                                    DateTime.now());
                                          }
                                        }),
                                  ),
                                )
                              ],
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                            ),
                            title: Text(
                              notes2[index].title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 30,
                            ),
                            subtitle: SizedBox(
                              // width: MediaQuery.of(context).size.width*0.2,
                              height: 90,
                              child: Column(
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      Text(notes2[index].content, maxLines: 1),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      if (notes2[index].category != '')
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical:
                                                  4.0), // Ajusta el padding según necesites
                                          decoration: BoxDecoration(
                                            color: colors
                                                .background, // Define el color de fondo
                                            borderRadius: BorderRadius.circular(
                                                20), // Define el borderRadius
                                          ),
                                          child: Text(notes2[index]
                                              .category), // Tu widget Text
                                        ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    children: [
                                      notes2[index].dateRemember !=
                                              DateTime(1, 1, 1, 0, 0)
                                          ? Text(
                                              'Recordar: ${DateFormat('dd MMM hh:mm a').format(notes2[index].dateRemember)}')
                                          : const Text(
                                              'Sin fecha para recordar')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onLongPress: () {
                              showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    TextEditingController titleController =
                                        TextEditingController(
                                            text: notes2[index].title);
                                    TextEditingController contentController =
                                        TextEditingController(
                                            text: notes2[index].content);

                                    return AlertDialog(
                                      title: const Text("Editar Recordatorio"),
                                      content: SizedBox(
                                        height: 300,
                                        width: 500,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Wrap(
                                              alignment: WrapAlignment.start,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              children: [
                                                Text(
                                                    'Creado: ${DateFormat('dd MMM hh:mm a').format(notes2[index].dateCreate)}')
                                              ],
                                            ),
                                            const Text("Recordatorio"),
                                            TextField(
                                              maxLines: 2,
                                              controller: titleController,
                                              decoration: const InputDecoration(

                                                  // hintText:
                                                  // notes[index]['title'].toString(),
                                                  ),
                                            ),
                                            const Text(
                                              "Descripción",
                                            ),
                                            TextField(
                                              maxLines: 2,
                                              controller: contentController,
                                              decoration: const InputDecoration(

                                                  // hintText:
                                                  // notes[index]['content'].toString(),
                                                  ),
                                            ),
                                            FilledButton(
                                                onPressed: () async {
                                                  await noteProvider
                                                      .updateNote(
                                                          notes2[index].key,
                                                          titleController.text,
                                                          contentController
                                                              .text)
                                                      .then((value) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            action: SnackBarAction(
                                                                textColor:
                                                                    Colors
                                                                        .black,
                                                                label: '¡Ok!',
                                                                onPressed:
                                                                    () {}),
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1100),
                                                            backgroundColor:
                                                                Colors.yellow[
                                                                    200],
                                                            content: const Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Icon(Icons
                                                                    .add_alert_sharp),
                                                                Text(
                                                                  "¡Recordatorio actualizado!",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ],
                                                            )));
                                                    context.pop();
                                                  });
                                                },
                                                child: const Text("Actualizar"))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            onTap: () {
                              String speechText = "";

                              if (ttsTitle && textToSpeech) {
                                speechText +=
                                    "Recordatorio ${notes2[index].title}. ";
                              }

                              if (ttsContent) {
                                if (notes2[index].content.isNotEmpty) {
                                  speechText +=
                                      "Descripción ${notes2[index].content}. ";
                                } else {
                                  speechText += "Sin descripción. ";
                                }
                              }

                              if (ttsCategory) {
                                if (notes2[index].category.isNotEmpty) {
                                  speechText +=
                                      "Categoría ${notes2[index].category}. ";
                                } else {
                                  speechText += "Sin categoría. ";
                                }
                              }

                              if (speechText.isNotEmpty) {
                                _speak(speechText);
                              }
                            },

                            // onTap: () async {

                            //  await Navigator.pushNamed(context, '/edit',arguments: {
                            //     "name": snapshot.data?[index]["name"],
                            //      "uid": snapshot.data?[index]["uid"]
                            //   });
                            //   setState(() {

                            //   });
                            // },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const SliverToBoxAdapter(
                    child: Center(),
                  );
                }
              },
            )
          : SliverToBoxAdapter(
              child: Column(
                children: [
                  isDarkMode
                      ? Image.asset(
                          "assets/images/notnotesdark.png",
                          height: 200,
                        )
                      : Image.asset(
                          "assets/images/notnotes.png",
                          height: 200,
                        ),
                  Center(
                    child: Text(
                      "Aún no hay recordatorios",
                      style: textStyle.titleLarge,
                    ),
                  ),
                ],
              ),
            );
    }
  }
}
