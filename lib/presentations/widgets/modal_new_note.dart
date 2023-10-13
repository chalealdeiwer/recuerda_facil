import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:recuerda_facil/config/notes/app_notes.dart';
import 'package:recuerda_facil/services/user_services.dart';

import '../providers/notes_provider2.dart';
import '../providers/providers.dart';

class ModalNewNote extends ConsumerStatefulWidget {
  const ModalNewNote({
    super.key,
  });

  @override
  ConsumerState<ModalNewNote> createState() => _ModalNewNoteState();
}

class _ModalNewNoteState extends ConsumerState<ModalNewNote> {
  String selectedCategory = 'Sin Categoría';
  String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
  // Categoría seleccionada inicialmente

  List<String> userCategories = [];
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? dateInput;
  TimeOfDay? hourInput;

  Future<void> _selectDate() async {
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
                          DateTime.now().add(Duration(days: 1))),
                      dateButton(context, "En 3 días",
                          DateTime.now().add(Duration(days: 3))),
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
                        Navigator.of(context).pop(selectedDate);
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
  daysUntilSaturday = daysUntilSaturday == 0 ? 7 : daysUntilSaturday; // Si hoy es sábado, se selecciona el próximo sábado
  return date.add(Duration(days: daysUntilSaturday));
}

DateTime nextSunday(DateTime date) {
  int daysUntilSunday = (DateTime.sunday - date.weekday + 7) % 7;
  daysUntilSunday = daysUntilSunday == 0 ? 7 : daysUntilSunday; // Si hoy es domingo, se selecciona el próximo domingo
  return date.add(Duration(days: daysUntilSunday));
}

DateTime nextMonday(DateTime date) {
  int daysUntilMonday = (DateTime.monday - date.weekday + 7) % 7;
  daysUntilMonday = daysUntilMonday == 0 ? 7 : daysUntilMonday; // Si hoy es lunes, se selecciona el próximo lunes
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

  Future<void> _selectHour() async {
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
                      );
                      if (selectedTime != null) {
                        Navigator.of(context).pop(selectedTime);
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

  // void getCategories() async {
  //   final categoriess = await getUserCategories(currentUserUID);
  //   if (mounted) {

  //       userCategories = categoriess;

  //   }
  // }

  // Widget categories() {
  //   getCategories();
  //   return Column(
  //     children: <Widget>[
  //       DropdownButton<String>(
  //         value: selectedCategory,
  //         onChanged: (String? newValue) {

  //             selectedCategory = newValue!;
  //             print(selectedCategory);

  //           selectedCategory = newValue!;
  //         },
  //         items: userCategories.map((String category) {
  //           return DropdownMenuItem<String>(
  //             value: category,
  //             child: Text(category),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final AppNotes noteProvider = ref.watch(noteNotifierProvider);
    final categoy = ref.watch(categoryProvider);
    

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
                  onPressed: () {
                    _selectDate();
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
                    onPressed: () {
                      _selectHour();
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
            // categories(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text(
                      "Cancelar",
                    )),
                const SizedBox(
                  width: 10,
                ),
                FilledButton(
                    onPressed: () async {
                      DateTime combinedDateTime = DateTime(
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
                      if (_formKey.currentState!.validate()) {
                        await noteProvider
                            .addNote(
                                _titleController.text,
                                _contentController.text,
                                FirebaseAuth.instance.currentUser!.uid
                                    .toString(),
                                DateTime.now(),
                                false,
                                categoy,
                                DateTime(1, 1, 1, 0, 0),
                                combinedDateTime,
                                Icons.note.codePoint.toString())
                            .then((value) => {
                              ref.refresh(remindersProvider(currentUserUID)),
                                  if(mounted)
                                  context.pop(),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
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
                                          backgroundColor: Colors.green[200],
                                          content: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.add_alert_sharp),
                                              Text(
                                                "¡Recordatorio agregado correctamente!",
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

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();

    super.dispose();
  }
}
