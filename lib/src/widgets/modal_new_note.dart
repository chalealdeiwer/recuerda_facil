import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recuerda_facil/providers/notes_provider.dart';
import 'package:recuerda_facil/services/user_services.dart';

class ModalNewNote extends StatefulWidget {
  const ModalNewNote({
    super.key,
  });

  @override
  State<ModalNewNote> createState() => _ModalNewNoteState();
}

class _ModalNewNoteState extends State<ModalNewNote> {
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
        setState(() {
          dateInput = value;
        });
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
        setState(() {
          hourInput = value;
        });
      }
    });
  }

  void getCategories() async {
    try {
      final categoriess = await getUserCategories(currentUserUID);

      setState(() {
        userCategories = categoriess;
      });
    } catch (error) {
      // Maneja cualquier error que pueda ocurrir durante la obtención de categorías
      print('Error al obtener categorías: $error');
    }
  }

  Widget categories() {
    getCategories();
    return Column(
      children: <Widget>[
        DropdownButton<String>(
          value: selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
              print(selectedCategory);
            });
          },
          items: userCategories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      // height: 300,
      // color: Colors.grey,
      child: Form(
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
              Row(
                children: [
                  FilledButton(
                    onPressed: () {
                      selectDate();
                    },
                    child: Text(
                      dateInput == null
                          ? "¿Cuando recordar?"
                          : DateFormat.yMEd('es').format(dateInput!),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  FilledButton(
                    onPressed: () {
                      selectHour();
                    },
                    child: Text(
                      hourInput == null
                          ? "¿A qué hora?"
                          : hourInput!.format(context),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              categories(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.red),
                      )),
                      const SizedBox(
                    width: 10,
                  ),

                  ElevatedButton(
                      onPressed: () async {
                        DateTime combinedDateTime = DateTime(
                          dateInput==null?DateTime.now().year:dateInput!.year,
                          dateInput==null?DateTime.now().month:dateInput!.month,
                          dateInput==null?DateTime.now().day:dateInput!.day,
                          hourInput==null?DateTime.now().hour:hourInput!.hour,
                          hourInput==null?DateTime.now().minute:hourInput!.minute,
                          
                          
                        );
                        if (_formKey.currentState!.validate()) {
                          await noteProvider.addNote(
                              _titleController.text,
                              _contentController.text,
                              FirebaseAuth.instance.currentUser!.uid.toString(),
                              DateTime.now(),
                              "pendiente",
                              selectedCategory,
                              combinedDateTime);
                          Navigator.of(context).pop(true);
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
                              )
                              );
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
