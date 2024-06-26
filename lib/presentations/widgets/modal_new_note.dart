import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:recuerda_facil/services/services.dart';

import '../providers/providers.dart';

class ModalNewNote extends ConsumerStatefulWidget {
  final String user;
  const ModalNewNote({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<ModalNewNote> createState() => _ModalNewNoteState();
}

class _ModalNewNoteState extends ConsumerState<ModalNewNote> {
  String selectedCategory = 'Sin Categoría';
  String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool notification = true;
  bool prenotification = false;
  bool alarm = false;

  DateTime combinedDateTime = DateTime(1, 1, 1, 0, 0);

  // Categoría seleccionada inicialmente

  List<String> userCategories = [];
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? dateInput;
  TimeOfDay? hourInput;

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
                      // minutesButton(context, 'En 1 minutos',
                      //     addMinutesToTimeOfDay(TimeOfDay.now(), 1)),
                      // minutesButton(context, 'En 2 ms',
                      //     addMinutesToTimeOfDay(TimeOfDay.now(), 2)),
                      // minutesButton(context, 'En 3 m',
                      //     addMinutesToTimeOfDay(TimeOfDay.now(), 3)),
                      // minutesButton(context, 'En 4 m',
                      //     addMinutesToTimeOfDay(TimeOfDay.now(), 4)),
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
  Widget build(BuildContext context) {
    final posting = ref.watch(noteNotifierProvider);
    final noteProvider = ref.watch(noteNotifierProvider.notifier);
    final category = ref.watch(categoryProvider);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              controller: _titleController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Este campo esta vacío';
                }
                return null;
              },
              decoration:
                  const InputDecoration(labelText: '¿Que desea recordar?'),
            ),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Wrap(
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: posting.isPosting
                      ? null
                      : () async {
                          await selectDate();
                          combinedDateTime = DateTime(
                            dateInput?.year ??
                                1, // Si dateInput es null, se usará el año 1
                            dateInput?.month ??
                                1, // Si dateInput es null, se usará el mes 1
                            dateInput?.day ??
                                1, // Si dateInput es null, se usará el día 1
                            hourInput?.hour ??
                                0, // Si hourInput es null, se usará la hora 0
                            hourInput?.minute ??
                                0, // Si hourInput es null, se usará el minuto 0
                          );
                          setState(() {});
                        },
                  label: Text(
                    dateInput == null
                        ? "¿Cuando recordar?"
                        : DateFormat.yMEd('es').format(dateInput!),
                    // style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                if (dateInput != null)
                  OutlinedButton.icon(
                    onPressed: posting.isPosting
                        ? null
                        : () async {
                            await selectHour();
                            combinedDateTime = DateTime(
                              dateInput?.year ??
                                  1, // Si dateInput es null, se usará el año 1
                              dateInput?.month ??
                                  1, // Si dateInput es null, se usará el mes 1
                              dateInput?.day ??
                                  1, // Si dateInput es null, se usará el día 1
                              hourInput?.hour ??
                                  0, // Si hourInput es null, se usará la hora 0
                              hourInput?.minute ??
                                  0, // Si hourInput es null, se usará el minuto 0
                            );

                            setState(() {});
                          },
                    icon: const Icon(Icons.watch),
                    label: Text(
                      hourInput == null
                          ? "¿A qué hora?"
                          : hourInput!.format(context),
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),

            if (hourInput != null && combinedDateTime.isAfter(DateTime.now()))
              SwitchListTile(
                value: notification,
                onChanged: (value) {
                  setState(() {
                    notification = value;
                    prenotification = false;
                  });
                },
                title: const Text("¿Notificación?"),
              ),

            if (hourInput != null &&
                combinedDateTime.isAfter(DateTime.now()) &&
                notification)
              SwitchListTile(
                value: prenotification,
                onChanged: (value) {
                  setState(() {
                    prenotification = value;
                  });
                },
                title: const Text("5 minutos antes"),
              ),

            // categories(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: posting.isPosting
                        ? null
                        : () {
                            context.pop();
                          },
                    child: const Text(
                      "Cancelar",
                    )),
                const SizedBox(
                  width: 10,
                ),
                FilledButton(
                    onPressed: posting.isPosting
                        ? null
                        : () async {
                            // combinedDateTime = DateTime(
                            //   dateInput?.year ??
                            //       1, // Si dateInput es null, se usará el año 1
                            //   dateInput?.month ??
                            //       1, // Si dateInput es null, se usará el mes 1
                            //   dateInput?.day ??
                            //       1, // Si dateInput es null, se usará el día 1
                            //   hourInput?.hour ??
                            //       0, // Si hourInput es null, se usará la hora 0
                            //   hourInput?.minute ??
                            //       0, // Si hourInput es null, se usará el minuto 0
                            // );
                            //notificación

                            if (_formKey.currentState!.validate()) {
                              if (combinedDateTime.isAfter(DateTime.now()) &&
                                  notification) {
                                // programNotification(combinedDateTime);
                                programNotification2(
                                  combinedDateTime,
                                  _titleController.text,
                                  _contentController.text,
                                );
                                programNotification(combinedDateTime);
                                DateTime fiveMinutesBeforeNow = DateTime.now()
                                    .subtract(const Duration(minutes: 5));

                                if (combinedDateTime
                                        .isAfter(fiveMinutesBeforeNow) &&
                                    prenotification) {
                                  programNotification3(
                                      combinedDateTime,
                                      _titleController.text,
                                      _contentController.text);
                                }
                              }

                              await noteProvider
                                  .addNote(
                                      _titleController.text,
                                      _contentController.text,
                                      widget.user,
                                      DateTime.now(),
                                      false,
                                      category,
                                      DateTime(1, 1, 1, 0, 0),
                                      combinedDateTime,
                                      Icons.note.codePoint.toString())
                                  .then((value) => {
                                        if (mounted) context.pop(),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                action: SnackBarAction(
                                                  textColor: Colors.black,
                                                  label: '¡Ok!',
                                                  onPressed: () {
                                                    // ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                                    // Code to execute.
                                                  },
                                                ),
                                                duration: const Duration(
                                                    milliseconds: 2000),
                                                backgroundColor:
                                                    Colors.green[200],
                                                content: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(Icons.add_alert_sharp),
                                                    Text(
                                                      "¡Recordatorio agregado!",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                )))
                                      });
                            }

                            // await NotesServices().saveNotes(

                            //   _titleController.text, _contentController.text
                            // );
                          },
                    child: const Text("Aceptar")),
              ],
            )
          ],
        ),
      ),
    );
  }

  void programNotification2(DateTime targetTime, title, content) async {
    final id = Random().nextInt(1000);
    final initialDuration = targetTime.isBefore(DateTime.now())
        ? targetTime.add(const Duration(days: 1)).difference(DateTime.now())
        : targetTime.difference(DateTime.now());

    await AndroidAlarmManager.oneShot(initialDuration, id, notification2,
        alarmClock: true,
        wakeup: true,
        allowWhileIdle: true,
        exact: true,
        rescheduleOnReboot: true,
        params: {'title': title, 'content': content});
  }

  void programNotification3(DateTime targetTime, title, content) async {
    // Ajustar el tiempo objetivo restando 5 minutos
    final targetTimeAdjusted = targetTime.subtract(const Duration(minutes: 5));

    final id = Random().nextInt(1000);
    final initialDuration = targetTimeAdjusted.isBefore(DateTime.now())
        ? targetTimeAdjusted
            .add(const Duration(days: 1))
            .difference(DateTime.now())
        : targetTimeAdjusted.difference(DateTime.now());

    await AndroidAlarmManager.oneShot(initialDuration, id, notification3,
        alarmClock: true,
        wakeup: true,
        allowWhileIdle: true,
        exact: true,
        rescheduleOnReboot: true,
        params: {'title': title, 'content': content});
  }

  void programNotification(DateTime targetTime) async {
    final id = Random().nextInt(1000);
    final initialDuration = targetTime.isBefore(DateTime.now())
        ? targetTime.add(const Duration(days: 1)).difference(DateTime.now())
        : targetTime.difference(DateTime.now());

    await AndroidAlarmManager.oneShot(
      initialDuration,
      id,
      alarmT,
      alarmClock: true,
      wakeup: true,
      allowWhileIdle: true,
      exact: true,
      rescheduleOnReboot: true,
    );
    // await AndroidAlarmManager.periodic(duration, id, callback)
  }

  // static myCallback(int id, Map<String, dynamic> para) async {
  //   final customParameter = para['customParameter'];
  //   await Future.delayed(const Duration(seconds: 1));
  //   return print(
  //       'Callback executed with custom parameter: $customParameter y el id$id');
  // }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();

    super.dispose();
  }
}
@pragma('vm:entry-point')
void notification2(int id, Map<String, dynamic> params) {
  showNotification2(
      id, "⌚Recordatorio: ${params["title"]} ", "${params["content"]}");
}

@pragma('vm:entry-point')
void notification3(int id, Map<String, dynamic> params) {
  showNotification2(
      id,
      "Un recordatorio esta próximo a vencer en 5 minutos: ${params["title"]} ",
      "${params["content"]}");
}

@pragma('vm:entry-point')
void alarmT() {
  final id = Random().nextInt(1000);
  showNotification2(id, "Un recordatorio esta esperando por ti, entra a la app para verlo",
      "");
}
