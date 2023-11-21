import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:recuerda_facil/features/auth/domain/entities/user_account.dart';
import 'package:recuerda_facil/presentations/widgets/widgets.dart';
import 'package:recuerda_facil/services/services.dart';

import '../../../../../presentations/providers/providers.dart';
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
  DateTime? dateInput;

  int currentStep = 0;

  continueStep() {
    setState(() {
      if (currentStep < 4 - 1) {
        currentStep += 1;
      } else {
        ref.read(authProvider.notifier).createUser(UserAccount(
              uid: FirebaseAuth.instance.currentUser!.uid,
              email: FirebaseAuth.instance.currentUser!.email,
              photoURL: FirebaseAuth.instance.currentUser!.photoURL,
              emailVerified: FirebaseAuth.instance.currentUser!.emailVerified,
              phoneNumber: phoneController.text,
              private: false,
              created: DateTime.now(),
              usersCarer: [],
              firstSignIn: false,
              categories: selectedCategories,
              displayName: nameController.text,
              dateBirthday: dateInput
            ));
      }
    });
  }

  cancelStep() {
    setState(() {
      if (currentStep > 0) {
        currentStep -= 1;
      } else {
        currentStep = 0;
      }
    });
  }

  onStepTapped(int step) {
    setState(() {
      currentStep = step;
    });
  }

  Widget controlsBuilder(context, details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FilledButton(
            onPressed: details.onStepContinue, child: const Text("Continuar")),
        OutlinedButton(
            onPressed: details.onStepCancel, child: const Text("Atrás"))
      ],
    );
  }

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
    'Trabajo',
    'Deporte',
    'Salud',
    'Medicamentos',
    'Cumpleaños',
    'Aniversarios',
    'Personal',
    'Compras',
  ];
  TextEditingController newCategoryController = TextEditingController();
  final TextEditingController nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);
  final TextEditingController phoneController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.phoneNumber);

  bool _categoryExists(String category) {
    return selectedCategories.contains(category);
  }

  bool _isPredefinedCategory(String category) {
    return predefinedCategories.contains(category);
  }

  int calculateAge(DateTime birthDate) {
    final DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    final int currentMonth = currentDate.month;
    final int birthMonth = birthDate.month;
    final int currentDay = currentDate.day;
    final int birthDay = birthDate.day;

    // Adjust if the birthday hasn't occurred yet in the current year
    if (birthMonth > currentMonth) {
      age--;
    } else if (birthMonth == currentMonth) {
      if (birthDay > currentDay) {
        age--;
      }
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    // final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    List<Step> steps = [
      Step(
          state: currentStep >= 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
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
                  "Teléfono(opcional)",
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
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        dateInput == null
                            ? "¿Fecha de cumpleaños?"
                            : DateFormat.yMEd('es').format(dateInput!),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      (dateInput != null)
                          ? Text(" Tienes ${calculateAge(dateInput!)} años")
                          : const SizedBox(
                              height: 0,
                            ),
                    ],
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
                      setState(() {
                        dateInput = selectedDate;
                      });
                    }
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
          ])),
      Step(
          state: currentStep >= 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('Paso 2 - Elige Apariencia'),
          content: Column(
            children: [
              SwitchListTile(
                title: Text(
                  "Modo Oscuro",
                  style: textStyle.titleLarge,
                ),
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeNotifierProvider.notifier).toogleDarkMode();
                  ref
                      .read(isDarkmodeProvider.notifier)
                      .update((darkmode) => !darkmode);
                  PreferencesUser().setValue<bool>('isDarkmode', !isDarkMode);
                },
              ),
              const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text("Escoge un color de tu agrado")),
              const SizedBox(height: 70, child: ThemeChangerView()),
            ],
          )),
      Step(
          state: currentStep >= 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
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
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
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
                                  predefinedCategories.add(newCategory);
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
                label: const Text('Añadir Categoría'),
              ),
              const SizedBox(height: 16.0),
            ],
          )),
      Step(
          state: currentStep >= 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text('Paso 4 - Disfruta tu aplicación'),
          content: const Text("Empezar a usar")),
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
                  onStepContinue: continueStep,
                  onStepCancel: cancelStep,
                  onStepTapped: onStepTapped,
                  controlsBuilder: controlsBuilder,
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
