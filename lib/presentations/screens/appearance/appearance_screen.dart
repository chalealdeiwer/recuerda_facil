import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/screens/screens.dart';

import '../../providers/providers.dart';

enum Appearance { simple, reducida, completa }

class AppearanceScreen extends ConsumerStatefulWidget {
  const AppearanceScreen({super.key});
  static const name = 'appearance_screen';

  @override
  ConsumerState<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends ConsumerState<AppearanceScreen> {
  Set<Appearance> selection = <Appearance>{
    Appearance.reducida,
  };
  @override
  Widget build(
    BuildContext context,
  ) {
    var isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final customBack = ref.watch(preferencesProvider).customBackground;
    final opacity = ref.watch(opacityProvider);
    final clockVisibility = ref.watch(preferencesProvider).clockVisibility;
    final bottomVisibility = ref.watch(preferencesProvider).bottomVisibility;
    final categoriesVisibility =
        ref.watch(preferencesProvider).categoriesVisibility;
    final appBarVisibility = ref.watch(preferencesProvider).appBarVisibility;
    final buttonMicrophone =
        ref.watch(preferencesProvider).buttonMicrophoneVisibility;
    final buttonNewNote =
        ref.watch(preferencesProvider).buttonNewNoteVisibility;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     // mainAxisSize: MainAxisSize.max,
            //     children: [
            //       const Text("Automático"),
            //       Switch(
            //         value: isautodark,
            //         onChanged: (value) {

            //           // ref.read(themeNotifierProvider.notifier).toogleDarkMode();
            //           // ref
            //           //     .read(isDarkmodeProvider.notifier)
            //           //     .update((darkmode) => !darkmode);

            //           isautodark = !isautodark;
            //           isDarkMode=false;
            //         },
            //       ),
            //     ],
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        " Tema de aplicación",
                        textScaleFactor: 1,
                        maxLines: 2,
                        style: textStyle.displaySmall,
                      ),
                      const Expanded(child: Divider())
                    ],
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
                                    .read(opacityProvider.notifier)
                                    .updateOpacity(newValue);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        " Apariencia",
                        textScaleFactor: 1,
                        maxLines: 2,
                        style: textStyle.displaySmall,
                      ),
                      const Expanded(child: Divider())
                    ],
                  ),
                  const SizedBox(
                    height: 10,
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
                          ref
                              .read(preferencesProvider.notifier)
                              .appearanceSimple();
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
                      "Barra de funciones",
                      style: textStyle.titleLarge,
                    ),
                    value: appBarVisibility,
                    onChanged: (value) {
                      ref
                          .read(preferencesProvider.notifier)
                          .changeAppBarVisibility(!appBarVisibility);
                      ref
                          .read(preferencesProvider.notifier)
                          .changeButtonActionVisibility(appBarVisibility);
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
                      ref
                          .read(preferencesProvider.notifier)
                          .changeCategoriesVisibility(!categoriesVisibility);
                      ref
                          .watch(categoryProvider.notifier)
                          .update((state) => "Todos");
                      ref
                          .watch(indexCategoryProvider.notifier)
                          .update((state) => 0);
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
                          .read(preferencesProvider.notifier)
                          .changeClockVisibility(!clockVisibility);
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
                          .read(preferencesProvider.notifier)
                          .changeButtonMicrophoneVisibility(!buttonMicrophone);
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
                          .read(preferencesProvider.notifier)
                          .changeButtonNewNoteVisibility(!buttonNewNote);
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
                          .read(preferencesProvider.notifier)
                          .changeBottomVisibility(!bottomVisibility);
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        " Vista previa",
                        style: textStyle.displaySmall,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),

            Center(
              child: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: colors.secondary.withOpacity(0.5))),
                width: size.width * 0.5,
                height: size.height * 0.5,
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

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Color de aplicación",
                    style: textStyle.titleLarge,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 70, child: ThemeChangerView()),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Apariencia"),
        leading: IconButton(
            onPressed: () {
              context.push('/home/1');
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                context.push('/home/1');
              },
              icon: const Icon(Icons.save))
        ],
      ),
    );
  }
}

class ThemeChangerView extends ConsumerWidget {
  const ThemeChangerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final List<Color> colors = ref.watch(colorListProvider);
    final selectedIndex = ref.watch(themeNotifierProvider).selectedColor;
    var isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: colors.length,
      itemExtent: 60.0, // Este valor determina el ancho de cada contenedor
      itemBuilder: (context, index) {
        final Color color = colors[index];
        return GestureDetector(
          onTap: () {
            ref.read(preferencesProvider.notifier).changeSelectedColor(index);
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: index == selectedIndex
                    ? (isDarkMode ? Colors.white : Colors.black)
                    : Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        );
      },
    );
  }
}
