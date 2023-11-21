import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/features/auth/domain/entities/user_account.dart';
import 'package:recuerda_facil/presentations/widgets/widgets.dart';

import '../../../../../presentations/screens/screens.dart';
import '../../providers/providers_auth.dart';

class FirstSignInScreen extends ConsumerStatefulWidget {
  final user = FirebaseAuth.instance.currentUser;

  static const String name = "FirstSignInScreen";
  FirstSignInScreen({super.key});

  @override
  ConsumerState<FirstSignInScreen> createState() => _FirstSignInScreenState();
}

class _FirstSignInScreenState extends ConsumerState<FirstSignInScreen> {
  List<String> selectedCategories = [
    'Todos',
    'Sin Categoría',
    'Trabajo',
    'Deporte',
    'Salud',
    'Medicamentos',
    'Cumpleaños',
  ];
  List<String> predefinedCategories = [
    'Lista de Compras',
    'Trabajo',
    'Deporte',
    'Salud',
    'Medicamentos',
    'Cumpleaños',
    'Aniversarios',
    'Personal'
  ];
  TextEditingController newCategoryController = TextEditingController();
  final TextEditingController nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);
  final TextEditingController phoneController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.phoneNumber);

  int currentStep = 0;
  bool _categoryExists(String category) {
    return selectedCategories.contains(category);
  }

  bool _isPredefinedCategory(String category) {
    return predefinedCategories.contains(category);
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
          title: const Text('Paso 1 - Completa alguna información personal'),
          content: Column(children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.user!.email!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 10,
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nombre",
                )),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: nameController.text.isEmpty
                      ? "Nombre"
                      : nameController.text,
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Teléfono",
                )),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                  hintText: phoneController.text.isEmpty
                      ? "Tu numero de teléfono"
                      : nameController.text,
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(
                      width: 2,
                    ),
                  ),
                  child: const Text(
                    'Fecha de cumpleaños',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onPressed: () async {
                    DateTime firstDate = DateTime(1900, 1, 1);
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
                      context.pop();
                    }
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
          ])),
      const Step(
          title: Text('Paso 2 - Elige Apariencia'),
          content: Column(
            children: [
              Text("Escoge un color de tu agrado"),
              SizedBox(height: 70, child: ThemeChangerView()),
            ],
          )),
      Step(
          title: const Text('Paso 3 - Preferencias de usuario'),
          content: Column(
            children: [
              const Text("Elige o crea categorías para tus recordatorios"),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  for (String category in predefinedCategories)
                    ChoiceChip(
                      label: Text(category),
                      selected: selectedCategories.contains(category),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      },
                    ),
                ],
              ),
              ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Añadir nueva categoría'),
                            content: TextField(
                              controller: newCategoryController,
                              decoration: const InputDecoration(
                                hintText: 'Nombre de la nueva categoría',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  final newCategory =
                                      newCategoryController.text.trim();
                                  if (newCategory.isNotEmpty &&
                                      !_categoryExists(newCategory) &&
                                      !_isPredefinedCategory(newCategory)) {
                                    setState(() {
                                      selectedCategories.add(newCategory);
                                      newCategoryController.clear();
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: const Text('Añadir'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Añadir Categoría'),
                  ),
              const SizedBox(height: 16.0),
              const Text("Categorías seleccionadas:"),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  for (String category in selectedCategories)
                    InputChip(
                      label: Text(category),
                      onDeleted: () {
                        if (category != 'Todos' &&
                            category != 'Sin Categoría') {
                          setState(() {
                            selectedCategories.remove(category);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("No puedes eliminar esta categoría"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  
                ],
              ),
            ],
          )),
      const Step(
          title: Text('Paso 4 - Disfruta tu aplicación'),
          content: Text("Empezar a usar")),
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                customTitle(context,
                    title1: "Recuerda", size1: 30, title2: "Fácil", size2: 25),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Primera vez en recuerda fácil, primeros pasos, y configuración inicial",
                      style: TextStyle(fontSize: 20),
                    )),
                Stepper(
                  physics: const AlwaysScrollableScrollPhysics(),
                  currentStep: currentStep,
                  steps: steps,
                  onStepContinue: () {
                    setState(() {
                      if (currentStep < steps.length - 1) {
                        currentStep += 1;
                      } else {
                        ref.read(authProvider.notifier).createUser(UserAccount(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              email: FirebaseAuth.instance.currentUser!.email,
                              photoURL:
                                  FirebaseAuth.instance.currentUser!.photoURL,
                              emailVerified: FirebaseAuth
                                  .instance.currentUser!.emailVerified,
                              private: false,
                              created: DateTime.now(),
                              usersCarer: [],
                              firstSignIn: false,
                              categories: selectedCategories,
                              displayName: nameController.text,
                            ));
                      }
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      if (currentStep > 0) {
                        currentStep -= 1;
                      } else {
                        currentStep = 0;
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                OutlinedButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).defaultCreateUser();
                    },
                    child: const Text("Saltar configuración Inicial"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
