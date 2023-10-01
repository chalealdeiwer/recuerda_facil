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

  void selectDate() async {
    DateTime selectedDate = DateTime.now(); // Fecha inicial seleccionada
    DateTime firstDate = DateTime.now(); // Fecha mínima permitida
    DateTime lastDate = DateTime(2024, 12, 31); // Fecha máxima permitida
    await showDatePicker(
      cancelText: "Cancelar",
      confirmText: "Ok",
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ).then((value) {
      if (value == null) {
        return;
      } else {
       
          dateInput = value;
        
        dateInput = value;
      }
    });
  }

  void selectHour() async {
    await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
                hour: DateTime.now().hour, minute: DateTime.now().minute))
        .then((value) {
      if (value == null) {
        return;
      } else {
       
          hourInput = value;
      
        hourInput = value;
      }
    });
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
    final categoy=ref.watch(categoryProvider);

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
                    selectDate();
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
                OutlinedButton.icon(
                  onPressed: () {
                    selectHour();
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
                        dateInput == null
                            ? DateTime.now().year
                            : dateInput!.year,
                        dateInput == null
                            ? DateTime.now().month
                            : dateInput!.month,
                        dateInput == null ? DateTime.now().day : dateInput!.day,
                        hourInput == null
                            ? DateTime.now().hour
                            : hourInput!.hour,
                        hourInput == null
                            ? DateTime.now().minute
                            : hourInput!.minute,
                      );
                      if (_formKey.currentState!.validate()) {
                        await noteProvider.addNote(
                            _titleController.text,
                            _contentController.text,
                            FirebaseAuth.instance.currentUser!.uid.toString(),
                            DateTime.now(),
                            "pendiente",
                            categoy,
                            combinedDateTime,
                            Icons.note.codePoint.toString()).then((value) =>{
                              context.pop(),
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            action: SnackBarAction(
                              textColor: Colors.black,
                              label: '¡Ok!',
                              onPressed: () {
                                // ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                // Code to execute.
                              },
                            ),
                            duration: const Duration(milliseconds: 2000),
                            backgroundColor: Colors.green[200],
                            content: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.add_alert_sharp),
                                Text(
                                  "¡Recordatorio agregado correctamente!",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            )
                            )
                            )

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
