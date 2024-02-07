import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:recuerda_facil/features/auth/presentation/providers/providers_auth.dart';

import '../providers/providers.dart';

class StreamListWidget extends ConsumerStatefulWidget {
  final bool done;
  const StreamListWidget({required this.done, super.key});

  @override
  ConsumerState<StreamListWidget> createState() => _StreamListWidgetState();
}

class _StreamListWidgetState extends ConsumerState<StreamListWidget> {
  late FlutterTts flutterTts; // Declara una variable para FlutterTts
  DateTime combinedDateTime = DateTime(1, 1, 1, 0, 0);

  DateTime? dateInput;
  TimeOfDay? hourInput;

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.speak(text);
  }

  Future<void> selectDate() async {
    final size = MediaQuery.of(context).size;

    await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Selecciona una fecha",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width * 0.6,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: <Widget>[
                      if (dateInput == null)
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Sin fecha")),
                      dateButton(context, "Hoy", DateTime.now()),
                      dateButton(context, "Mañana",
                          DateTime.now().add(const Duration(days: 1))),
                      dateButton(context, "En 3 días",
                          DateTime.now().add(const Duration(days: 3))),
                      dateButton(
                          context, "Este sábado", nextSaturday(DateTime.now())),
                      dateButton(
                          context, "Este domingo", nextSunday(DateTime.now())),
                      dateButton(
                          context, "Próximo lunes", nextMonday(DateTime.now())),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                    child: const Text(
                      'Ó Personaliza una fecha 📅',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    onPressed: () async {
                      DateTime firstDate = DateTime(1999, 1, 1);
                      DateTime lastDate = DateTime(2030, 12, 31);
                      DateTime? selectedDate = await showDatePicker(
                        cancelText: "Cancelar",
                        confirmText: "Ok",
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );
                      if (selectedDate != null) {
                        if (mounted) {
                          Navigator.of(context).pop(selectedDate);
                        }
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          dateInput = selectedDate;
        });
      }
    });
  }

  DateTime nextSaturday(DateTime date) {
    int daysUntilSaturday = (DateTime.saturday - date.weekday + 7) % 7;
    daysUntilSaturday = daysUntilSaturday == 0
        ? 7
        : daysUntilSaturday; // Si hoy es sábado, se selecciona el próximo sábado
    return date.add(Duration(days: daysUntilSaturday));
  }

  DateTime nextSunday(DateTime date) {
    int daysUntilSunday = (DateTime.sunday - date.weekday + 7) % 7;
    daysUntilSunday = daysUntilSunday == 0
        ? 7
        : daysUntilSunday; // Si hoy es domingo, se selecciona el próximo domingo
    return date.add(Duration(days: daysUntilSunday));
  }

  DateTime nextMonday(DateTime date) {
    int daysUntilMonday = (DateTime.monday - date.weekday + 7) % 7;
    daysUntilMonday = daysUntilMonday == 0
        ? 7
        : daysUntilMonday; // Si hoy es lunes, se selecciona el próximo lunes
    return date.add(Duration(days: daysUntilMonday));
  }

  Widget dateButton(BuildContext context, String label, DateTime date) {
    return OutlinedButton(
      onPressed: () {
        Navigator.of(context).pop(date);
      },
      child: Text(label),
    );
  }

  Future<void> selectHour() async {
    final size = MediaQuery.of(context).size;
    await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Selecciona una hora",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width * 0.6,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: <Widget>[
                      if (hourInput == null)
                        OutlinedButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text("Sin hora")),
                      minutesButton(context, 'En 1 minutos',
                          addMinutesToTimeOfDay(TimeOfDay.now(), 1)),
                      minutesButton(context, 'En 2 minutos',
                          addMinutesToTimeOfDay(TimeOfDay.now(), 2)),
                      minutesButton(context, 'En 3 minutos',
                          addMinutesToTimeOfDay(TimeOfDay.now(), 3)),
                      minutesButton(context, 'En 4 minutos',
                          addMinutesToTimeOfDay(TimeOfDay.now(), 4)),
                      minutesButton(context, 'En 5 minutos',
                          addMinutesToTimeOfDay(TimeOfDay.now(), 5)),
                      minutesButton(context, 'En 10 minutos',
                          addMinutesToTimeOfDay(TimeOfDay.now(), 10)),

                      hourButton(context, '6:00 AM', 6, 0),
                      hourButton(context, '7:00 AM', 7, 0),
                      hourButton(context, '9:00 AM', 9, 0),
                      hourButton(context, '10:00 AM', 10, 0),
                      hourButton(context, '12:00 PM', 12, 0),
                      hourButton(context, '2:00 PM', 14, 0),
                      hourButton(context, '4:00 PM', 16, 0),
                      hourButton(context, '6:00 PM', 18, 0),
                      hourButton(context, '7:00 PM', 19, 0),

                      // Agrega más opciones predeterminadas según sea necesario
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                    child: const Text(
                      'Ó Personaliza una hora⌚',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                    onPressed: () async {
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return child!;
                        },
                      );
                      if (selectedTime != null) {
                        if (mounted) {
                          Navigator.of(context).pop(selectedTime);
                        }
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          hourInput = selectedTime;
          // Haz algo con la hora seleccionada
        });
      }
    });
  }

  Widget hourButton(
      BuildContext context, String hourLabel, int hour, int minute) {
    return OutlinedButton(
      child: Text(hourLabel),
      onPressed: () {
        Navigator.of(context).pop(TimeOfDay(hour: hour, minute: minute));
      },
    );
  }

  Widget minutesButton(BuildContext context, String label, TimeOfDay date) {
    return OutlinedButton(
      child: Text(label),
      onPressed: () {
        Navigator.of(context)
            .pop(TimeOfDay(hour: date.hour, minute: date.minute));
      },
    );
  }

  TimeOfDay addMinutesToTimeOfDay(TimeOfDay time, int minutesToAdd) {
    final minutes = time.hour * 60 + time.minute + minutesToAdd;
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(categoryProvider.notifier).state;
    final user = ref.watch(authProvider).user;
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final noteProvider = ref.read(noteNotifierProvider.notifier);
    final ttsTitle = ref.watch(ttsTitleProvider);
    final ttsContent = ref.watch(ttsContentProvider);
    final ttsCategory = ref.watch(ttsCategoryProvider);
    final textToSpeech = ref.watch(onTestToSpeechProvider);
    final updating = ref.watch(noteNotifierProvider);
    bool notification = true;
    bool prenotification = false;

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
                        direction: DismissDirection.horizontal,
                        background: Container(
                          color: Colors.red[400],
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.delete, size: 35),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.delete, size: 35),
                              ),
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
                        direction: DismissDirection.horizontal,
                        background: Container(
                          color: Colors.red[400],
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.delete, size: 35),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.delete, size: 35),
                              ),
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
                                    if (notes2[index].dateRemember !=
                                        DateTime(1, 1, 1, 0, 0)) {
                                      dateInput = notes2[index].dateRemember;
                                      hourInput = TimeOfDay.fromDateTime(
                                          notes2[index].dateRemember);
                                    } else {
                                      dateInput = null;
                                      hourInput = null;
                                    }

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
                                            // Wrap(
                                            //   children: [
                                            //     OutlinedButton.icon(
                                            //       icon: const Icon(
                                            //           Icons.calendar_month),
                                            //       onPressed: updating.isUpdating
                                            //           ? null
                                            //           : () async {
                                            //               await selectDate();
                                            //               combinedDateTime =
                                            //                   DateTime(
                                            //                 dateInput?.year ??
                                            //                     1, // Si dateInput es null, se usará el año 1
                                            //                 dateInput?.month ??
                                            //                     1, // Si dateInput es null, se usará el mes 1
                                            //                 dateInput?.day ??
                                            //                     1, // Si dateInput es null, se usará el día 1
                                            //                 hourInput?.hour ??
                                            //                     0, // Si hourInput es null, se usará la hora 0
                                            //                 hourInput?.minute ??
                                            //                     0, // Si hourInput es null, se usará el minuto 0
                                            //               );

                                            //               setState(() {});
                                            //             },
                                            //       label: Text(
                                            //         dateInput == null
                                            //             ? "¿Cuando recordar??"
                                            //             : DateFormat.yMEd('es')
                                            //                 .format(dateInput!),
                                            //         // style: TextStyle(color: Colors.white),
                                            //       ),
                                            //     ),
                                            //     const SizedBox(
                                            //       width: 2,
                                            //     ),
                                            //     if (dateInput != null)
                                            //       OutlinedButton.icon(
                                            //         onPressed: updating
                                            //                 .isUpdating
                                            //             ? null
                                            //             : () async {
                                            //                 await selectHour();
                                            //                 combinedDateTime =
                                            //                     DateTime(
                                            //                   dateInput?.year ??
                                            //                       1, // Si dateInput es null, se usará el año 1
                                            //                   dateInput
                                            //                           ?.month ??
                                            //                       1, // Si dateInput es null, se usará el mes 1
                                            //                   dateInput?.day ??
                                            //                       1, // Si dateInput es null, se usará el día 1
                                            //                   hourInput?.hour ??
                                            //                       0, // Si hourInput es null, se usará la hora 0
                                            //                   hourInput
                                            //                           ?.minute ??
                                            //                       0, // Si hourInput es null, se usará el minuto 0
                                            //                 );
                                            //                 setState(() {});
                                            //               },
                                            //         icon:
                                            //             const Icon(Icons.watch),
                                            //         label: Text(
                                            //           hourInput == null
                                            //               ? "¿A qué hora?"
                                            //               : hourInput!
                                            //                   .format(context),
                                            //           // style: TextStyle(color: Colors.white),
                                            //         ),
                                            //       ),
                                            //   ],
                                            // ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: FilledButton(
                                                  onPressed: updating.isUpdating
                                                      ? null
                                                      : () async {
                                                          await noteProvider
                                                              .updateNote(
                                                                  notes2[index]
                                                                      .key,
                                                                  titleController
                                                                      .text,
                                                                  contentController
                                                                      .text)
                                                              .then((value) {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                    action: SnackBarAction(
                                                                        textColor:
                                                                            Colors
                                                                                .black,
                                                                        label:
                                                                            '¡Ok!',
                                                                        onPressed:
                                                                            () {}),
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            1100),
                                                                    backgroundColor:
                                                                        Colors.yellow[
                                                                            200],
                                                                    content:
                                                                        const Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Icon(Icons
                                                                            .add_alert_sharp),
                                                                        Text(
                                                                          "¡Recordatorio actualizado!",
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        ),
                                                                      ],
                                                                    )));
                                                            context.pop();
                                                          });
                                                        },
                                                  child:
                                                      const Text("Actualizar")),
                                            )
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
