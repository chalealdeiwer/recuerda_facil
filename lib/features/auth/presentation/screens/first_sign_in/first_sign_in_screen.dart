import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:recuerda_facil/features/auth/domain/entities/user_account.dart';
import 'package:recuerda_facil/services/services.dart';

import '../../../../../presentations/providers/providers.dart';
import '../../../../../presentations/screens/screens.dart';
import '../../providers/providers_auth.dart';

enum Appearance { simple, reducida, completa }

class FirstSignInScreen extends ConsumerStatefulWidget {
  final user = FirebaseAuth.instance.currentUser;

  static const String name = "FirstSignInScreen";
  FirstSignInScreen({super.key});

  @override
  ConsumerState<FirstSignInScreen> createState() => _FirstSignInScreenState();
}

class _FirstSignInScreenState extends ConsumerState<FirstSignInScreen> {
  Set<Appearance> selection = <Appearance>{
    Appearance.reducida,
  };
  String initialCountry = 'CO';
  PhoneNumber number = PhoneNumber(isoCode: 'CO');
  DateTime? dateInput;
  bool privateAccount = false;

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
            phoneNumber: phoneNumber,
            private: privateAccount,
            created: DateTime.now(),
            usersCarer: [],
            firstSignIn: false,
            categories: selectedCategories,
            displayName: nameController.text,
            dateBirthday: dateInput));
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
            icon: const Icon(Icons.arrow_upward),
            onPressed: details.onStepCancel,
            label: const Text("Atrás")),
        FilledButton.icon(
            icon: const Icon(Icons.arrow_downward),
            onPressed: details.onStepContinue,
            label: const Text("Continuar")),
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
  String phoneNumber = "";

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
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final customBack = ref.watch(customBackground);
    final opacity = ref.watch(opacityProvider);
    final clockVisibility = ref.watch(clockVisibilityProvider);
    final bottomVisibility = ref.watch(bottomVisibilityProvider);
    final categoriesVisibility = ref.watch(categoriesVisibilityProvider);
    final appBarVisibility = ref.watch(appBarVisibilityProvider);
    final buttonMicrophone = ref.watch(buttonMicrophoneVisibilityProvider);
    final buttonNewNote = ref.watch(buttonNewNoteVisibilityProvider);

    List<Step> steps = [
      Step(
          state: currentStep >= 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('Paso 1 - Completa alguna información personal'),
          content: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widget.user!.photoURL != null
                    ? CircleAvatar(
                        minRadius: 40,
                        maxRadius: 40,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            Image.network(widget.user!.photoURL!).image,
                      )
                    : CircleAvatar(
                        minRadius: 40,
                        maxRadius: 40,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            Image.asset("assets/images/userphoto.png").image,
                      ),
              ],
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "(${widget.user!.email!})",
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
            // TextFormField(
            //   maxLength: 15,
            //   keyboardType: TextInputType.phone,
            //   controller: phoneController,
            //   decoration: InputDecoration(
            //       hintText: phoneController.text.isEmpty
            //           ? "Tu numero de teléfono"
            //           : nameController.text,
            //       border: const OutlineInputBorder()),
            // ),
            InternationalPhoneNumberInput(
              textFieldController: phoneController,
              onInputChanged: (PhoneNumber number) {
                phoneNumber = number.phoneNumber!;
                // Acción cuando cambia el número
              },
              onInputValidated: (bool value) {
                // Acción cuando se valida el número
              },
              selectorConfig: const SelectorConfig(
                showFlags: true,
                setSelectorButtonAsPrefixIcon: true,
              ),
              initialValue: number,
              inputBorder: const OutlineInputBorder(),
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
                            ? "¿Fecha de nacimiento?(opcional)"
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
                    DateTime lastDate = DateTime.now();
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
            SwitchListTile(
              title: Text("Cuenta privada", style: textStyle.titleLarge),
              value: privateAccount,
              onChanged: (value) {
                setState(() {
                  privateAccount = value;
                });
              },
            ),
            if (privateAccount)
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tu cuenta será privada, las otras personas no podrán encontrar tu cuenta  ",
                    style: TextStyle(fontSize: 20),
                  )),
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
              const Text(
                  "¿Como te gustaría ver la apariencia de tu aplicación?"),
              SegmentedButton<Appearance>(
                multiSelectionEnabled: false,
                segments: const [
                  ButtonSegment<Appearance>(
                    value: Appearance.simple,
                    icon: Icon(Icons.library_add_check_outlined),
                    label: Text("Simple "),
                  ),
                  ButtonSegment<Appearance>(
                    value: Appearance.reducida,
                    icon: Icon(Icons.library_add_check_outlined),
                    label: Text("Reducida "),
                  ),
                  ButtonSegment<Appearance>(
                      value: Appearance.completa,
                      label: Text("Completa "),
                      icon: Icon(Icons.library_add_check_outlined))
                ],
                selected: selection,
                onSelectionChanged: (value) {
                  Set simple = {Appearance.simple};
                  Set reducida = {Appearance.reducida};
                  Set completa = {Appearance.completa};
                  setState(() {
                    if (simple.containsAll(value)) {
                      selection = value;
                      //barra de funciones
                      ref
                          .read(appBarVisibilityProvider.notifier)
                          .update((appBarVisibility) => false);
                      ref
                          .read(buttonActionVisibilityProvider.notifier)
                          .update((buttonAction) => true);
                      PreferencesUser()
                          .setValue<bool>('buttonActionVisibility', true);
                      PreferencesUser()
                          .setValue<bool>('appBarVisibility', false);

                      //selector de categoría
                      ref
                          .read(categoriesVisibilityProvider.notifier)
                          .update((categoriesVisibility) => false);
                      ref
                          .watch(categoryProvider.notifier)
                          .update((state) => "Todos");
                      ref
                          .watch(indexCategoryProvider.notifier)
                          .update((state) => 0);
                      PreferencesUser()
                          .setValue<bool>('categoriesVisibility', false);
                      //mensaje de bienvenida
                      ref
                          .read(clockVisibilityProvider.notifier)
                          .update((clockVisibility) => false);
                      PreferencesUser()
                          .setValue<bool>('clockVisibility', false);
                      //botón comando de voz
                      ref
                          .read(buttonMicrophoneVisibilityProvider.notifier)
                          .update((buttonMicrophone) => true);
                      PreferencesUser()
                          .setValue<bool>('buttonMicrophoneVisibility', true);
                      //botón nueva nota
                      ref
                          .read(buttonNewNoteVisibilityProvider.notifier)
                          .update((buttonNewNote) => false);
                      PreferencesUser()
                          .setValue<bool>('buttonNewNoteVisibility', false);
                      //botones de pantalla
                      ref
                          .read(bottomVisibilityProvider.notifier)
                          .update((bottomVisibility) => false);
                      PreferencesUser()
                          .setValue<bool>('bottomVisibility', false);
                    }
                    if (reducida.containsAll(value)) {
                      selection = value;
                      //barra de funciones
                      ref
                          .read(appBarVisibilityProvider.notifier)
                          .update((appBarVisibility) => false);
                      ref
                          .read(buttonActionVisibilityProvider.notifier)
                          .update((buttonAction) => true);
                      PreferencesUser()
                          .setValue<bool>('buttonActionVisibility', true);
                      PreferencesUser()
                          .setValue<bool>('appBarVisibility', false);

                      //selector de categoría
                      ref
                          .read(categoriesVisibilityProvider.notifier)
                          .update((categoriesVisibility) => true);
                      ref
                          .watch(categoryProvider.notifier)
                          .update((state) => "Todos");
                      ref
                          .watch(indexCategoryProvider.notifier)
                          .update((state) => 0);
                      PreferencesUser()
                          .setValue<bool>('categoriesVisibility', true);
                      //mensaje de bienvenida
                      ref
                          .read(clockVisibilityProvider.notifier)
                          .update((clockVisibility) => true);
                      PreferencesUser().setValue<bool>('clockVisibility', true);
                      //botón comando de voz
                      ref
                          .read(buttonMicrophoneVisibilityProvider.notifier)
                          .update((buttonMicrophone) => true);
                      PreferencesUser()
                          .setValue<bool>('buttonMicrophoneVisibility', true);
                      //botón nueva nota
                      ref
                          .read(buttonNewNoteVisibilityProvider.notifier)
                          .update((buttonNewNote) => true);
                      PreferencesUser()
                          .setValue<bool>('buttonNewNoteVisibility', true);
                      //botones de pantalla
                      ref
                          .read(bottomVisibilityProvider.notifier)
                          .update((bottomVisibility) => false);
                      PreferencesUser()
                          .setValue<bool>('bottomVisibility', false);
                    }
                    if (completa.containsAll(value)) {
                      selection = value;
                      //barra de funciones
                      ref
                          .read(appBarVisibilityProvider.notifier)
                          .update((appBarVisibility) => true);
                      ref
                          .read(buttonActionVisibilityProvider.notifier)
                          .update((buttonAction) => false);
                      PreferencesUser()
                          .setValue<bool>('buttonActionVisibility', false);
                      PreferencesUser()
                          .setValue<bool>('appBarVisibility', true);

                      //selector de categoría
                      ref
                          .read(categoriesVisibilityProvider.notifier)
                          .update((categoriesVisibility) => true);
                      ref
                          .watch(categoryProvider.notifier)
                          .update((state) => "Todos");
                      ref
                          .watch(indexCategoryProvider.notifier)
                          .update((state) => 0);
                      PreferencesUser()
                          .setValue<bool>('categoriesVisibility', true);
                      //mensaje de bienvenida
                      ref
                          .read(clockVisibilityProvider.notifier)
                          .update((clockVisibility) => true);
                      PreferencesUser().setValue<bool>('clockVisibility', true);
                      //botón comando de voz
                      ref
                          .read(buttonMicrophoneVisibilityProvider.notifier)
                          .update((buttonMicrophone) => true);
                      PreferencesUser()
                          .setValue<bool>('buttonMicrophoneVisibility', true);
                      //botón nueva nota
                      ref
                          .read(buttonNewNoteVisibilityProvider.notifier)
                          .update((buttonNewNote) => true);
                      PreferencesUser()
                          .setValue<bool>('buttonNewNoteVisibility', true);
                      //botones de pantalla
                      ref
                          .read(bottomVisibilityProvider.notifier)
                          .update((bottomVisibility) => true);
                      PreferencesUser()
                          .setValue<bool>('bottomVisibility', true);
                    }
                  });
                },
              ),
              const SizedBox(
                height: 5,
              ),
              ExpansionTile(
                title: const Text("Opciones de apariencia completa"),
                children: [
                  SingleChildScrollView(
                    child: SwitchListTile(
                      title: Text(
                        "Fondo personalizado",
                        style: textStyle.titleLarge,
                      ),
                      value: customBack,
                      onChanged: (value) {
                        ref
                            .read(customBackground.notifier)
                            .update((customBack) => !customBack);
                        PreferencesUser()
                            .setValue<bool>('customBackground', !customBack);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Visibility(
                      visible: customBack,
                      child: Row(
                        children: [
                          Text(
                            "Opacidad",
                            style: textStyle.titleLarge,
                          ),
                          Expanded(
                            child: Slider(
                              value: opacity,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (newValue) {
                                ref
                                    .read(opacityProvider.notifier)
                                    .updateOpacity(newValue);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: Text(
                      "Barra de funciones",
                      style: textStyle.titleLarge,
                    ),
                    value: appBarVisibility,
                    onChanged: (value) {
                      ref
                          .read(appBarVisibilityProvider.notifier)
                          .update((appBarVisibility) => !appBarVisibility);
                      ref
                          .read(buttonActionVisibilityProvider.notifier)
                          .update((buttonAction) => !buttonAction);
                      PreferencesUser()
                          .setValue<bool>('buttonActionVisibility', !value);
                      PreferencesUser().setValue<bool>(
                          'appBarVisibility', !appBarVisibility);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Visibility(
                      visible: !appBarVisibility,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Se agregará un botón de acción",
                            textScaleFactor: 1,
                            style: TextStyle(color: colors.error, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: Text(
                      "Selector de categoría",
                      style: textStyle.titleLarge,
                    ),
                    value: categoriesVisibility,
                    onChanged: (value) {
                      ref.read(categoriesVisibilityProvider.notifier).update(
                          (categoriesVisibility) => !categoriesVisibility);
                      ref
                          .watch(categoryProvider.notifier)
                          .update((state) => "Todos");
                      ref
                          .watch(indexCategoryProvider.notifier)
                          .update((state) => 0);
                      PreferencesUser().setValue<bool>(
                          'categoriesVisibility', !categoriesVisibility);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Visibility(
                      visible: !categoriesVisibility,
                      child: Text(
                        "Los recordatorios nuevos se agregaran a 'Sin Categoría'",
                        style: TextStyle(color: colors.error, fontSize: 20),
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: Text(
                      "Mensaje de bienvenida",
                      style: textStyle.titleLarge,
                    ),
                    value: clockVisibility,
                    onChanged: (value) async {
                      ref
                          .read(clockVisibilityProvider.notifier)
                          .update((clockVisibility) => !clockVisibility);
                      PreferencesUser()
                          .setValue<bool>('clockVisibility', !clockVisibility);
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      "Botón Comando de Voz",
                      style: textStyle.titleLarge,
                    ),
                    value: buttonMicrophone,
                    onChanged: (value) {
                      ref
                          .read(buttonMicrophoneVisibilityProvider.notifier)
                          .update((buttonMicrophone) => !buttonMicrophone);
                      PreferencesUser().setValue<bool>(
                          'buttonMicrophoneVisibility', !buttonMicrophone);
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      "Botón de nueva nota",
                      style: textStyle.titleLarge,
                    ),
                    value: buttonNewNote,
                    onChanged: (value) {
                      ref
                          .read(buttonNewNoteVisibilityProvider.notifier)
                          .update((buttonNewNote) => !buttonNewNote);
                      PreferencesUser().setValue<bool>(
                          'buttonNewNoteVisibility', !buttonNewNote);
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      "Botones de pantalla",
                      style: textStyle.titleLarge,
                    ),
                    value: bottomVisibility,
                    onChanged: (value) {
                      ref
                          .read(bottomVisibilityProvider.notifier)
                          .update((bottomVisibility) => !bottomVisibility);
                      PreferencesUser().setValue<bool>(
                          'bottomVisibility', !bottomVisibility);
                    },
                  ),
                ],
              )
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
                        title: const Text(
                          'Añadir nueva categoría',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: TextField(
                          maxLength: 30,
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
                label: const Text(
                  'Añadir Categoría',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          )),
      Step(
          state: currentStep >= 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text('Paso 4 - Disfruta tu aplicación'),
          content: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Empezar a usar",
                style: TextStyle(fontSize: 20),
              ))),
    ];
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Recuerda",
                          style: TextStyle(
                              fontFamily: 'SpicyRice-Regular',
                              fontSize: 30,
                              color: colors.primary),
                          textScaleFactor: 1,
                        ),
                        Text(
                          "Fácil",
                          style: TextStyle(
                              fontFamily: 'SpicyRice-Regular',
                              fontSize: 25,
                              color: colors.secondary),
                          textScaleFactor: 1,
                        ),
                      ],
                    )),
                FilledButton.icon(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          // ignore: prefer_const_constructors
                          return AlertDialog(
                            title: const Text("Información"),
                            content: const Text(
                              "¿Estas seguro que deseas saltar configuración inicial? La configuración inicial te permite elegir preferencias y configurar tu app de recordatorios, si omites se creara la cuenta por defecto y podrás configurar más tarde.",
                              style: TextStyle(fontSize: 20),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text("Cancelar")),
                              FilledButton(
                                  onPressed: () {
                                    ref
                                        .read(authProvider.notifier)
                                        .defaultCreateUser();
                                  },
                                  child: const Text("Aceptar")),
                            ],
                          );
                        },
                      );
                    },
                    label: const Text("Omitir")),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Primera vez en recuerda fácil, primeros pasos, y configuración inicial",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            Stepper(
              physics: const AlwaysScrollableScrollPhysics(),
              currentStep: currentStep,
              steps: steps,
              onStepContinue: continueStep,
              onStepCancel: cancelStep,
              onStepTapped: onStepTapped,
              controlsBuilder: controlsBuilder,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SizedBox(
              height: size.height * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}
