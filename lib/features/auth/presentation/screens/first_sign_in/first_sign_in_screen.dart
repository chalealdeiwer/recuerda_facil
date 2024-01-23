import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:recuerda_facil/features/auth/domain/entities/user_account.dart';

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
    final customBack = ref.watch(preferencesProvider).customBackground;
    final opacity = ref.watch(preferencesProvider).opacity;

    List<Step> steps = [
      Step(
          state: currentStep >= 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text(''),
          // title: const Text('Info Personal'),
          content: Column(children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Es tu primera vez en recuerda fácil, llena algo de información, y luego continua con la configuración inicial",
                    style: TextStyle(fontSize: 16),
                  )),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Paso 1 - Completa alguna información personal',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ),
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
            InternationalPhoneNumberInput(
              hintText: phoneController.text.isEmpty
                  ? "Teléfono"
                  : phoneController.text,
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
          title: const Text(''),
          content: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Paso 2 - Elige Apariencia',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "¿Como te gustaría ver la apariencia de tu aplicación?",
                style: TextStyle(fontSize: 16),
              ),
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

                      ref
                          .watch(categoryProvider.notifier)
                          .update((state) => "Todos");
                      ref
                          .watch(indexCategoryProvider.notifier)
                          .update((state) => 0);
                      ref.read(preferencesProvider.notifier).appearanceSimple();
                    }
                    if (reducida.containsAll(value)) {
                      selection = value;

                      ref
                          .watch(categoryProvider.notifier)
                          .update((state) => "Todos");
                      ref
                          .watch(indexCategoryProvider.notifier)
                          .update((state) => 0);
                      ref
                          .read(preferencesProvider.notifier)
                          .appearanceReduced();
                    }
                    if (completa.containsAll(value)) {
                      selection = value;

                      ref
                          .watch(categoryProvider.notifier)
                          .update((state) => "Todos");
                      ref
                          .watch(indexCategoryProvider.notifier)
                          .update((state) => 0);
                      ref
                          .read(preferencesProvider.notifier)
                          .appearanceComplete();
                    }
                  });
                },
              ),
              SwitchListTile(
                title: Text(
                  "Modo Oscuro",
                  style: textStyle.titleLarge,
                ),
                value: isDarkMode,
                onChanged: (value) {
                  ref
                      .read(preferencesProvider.notifier)
                      .changeIsDarkMode(!isDarkMode);
                },
              ),
              SwitchListTile(
                title: Text(
                  "Fondo personalizado",
                  style: textStyle.titleLarge,
                ),
                value: customBack,
                onChanged: (value) {
                  ref
                      .read(preferencesProvider.notifier)
                      .changeCustomBackground(!customBack);
                },
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
                                .read(preferencesProvider.notifier)
                                .changeOpacity(newValue);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "Vista previa",
                style: textStyle.titleLarge,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: colors.secondary.withOpacity(0.5))),
                  width: size.width * 0.2,
                  height: size.height * 0.2,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IgnorePointer(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: HomeScreen(
                            pageIndex: 1,
                          )),
                    ),
                  ),
                ),
              ),
              const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text("Escoge un color de tu agrado")),
              const SizedBox(height: 70, child: ThemeChangerView()),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
      Step(
          state: currentStep >= 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text(''),
          content: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Paso 3 - Preferencias de usuario',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ),
              const SizedBox(height: 10,),
              const Text("Elige o crea categorías para tus recordatorios",style: TextStyle(fontSize: 16),),
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
          title: const Text(''),
          content: const Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Paso 4 - Disfruta tu aplicación',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Empezar a usar",
                    style: TextStyle(fontSize: 16),
                  )),
            ],
          )),
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
                              "¿Estas seguro que deseas saltar configuración inicial? La configuración inicial te permite elegir preferencias y configurar tu app de recordatorios, si omites se creará la cuenta por defecto y podrás configurar más tarde.",
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
                                    //creación de usuario
                                    ref
                                        .read(authProvider.notifier)
                                        .defaultCreateUser();
                                    ref
                                        .read(preferencesProvider.notifier)
                                        .appearanceDefault();

                                    ref
                                        .watch(categoryProvider.notifier)
                                        .update((state) => "Todos");
                                    ref
                                        .watch(indexCategoryProvider.notifier)
                                        .update((state) => 0);
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
                    "Completa todos los pasos y disfruta tu aplicación",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Stepper(
                physics: const AlwaysScrollableScrollPhysics(),
                currentStep: currentStep,
                type: StepperType.horizontal,
                steps: steps,
                onStepContinue: continueStep,
                onStepCancel: cancelStep,
                onStepTapped: onStepTapped,
                controlsBuilder: controlsBuilder,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
