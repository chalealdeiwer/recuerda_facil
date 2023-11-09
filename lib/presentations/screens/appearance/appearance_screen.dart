import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/screens/screens.dart';
import 'package:recuerda_facil/services/services.dart';

import '../../providers/providers.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});
  static const name = 'appearance_screen';

  @override
  Widget build(BuildContext context, ref) {
    var isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final customBack = ref.watch(customBackground);
    final opacity = ref.watch(opacityProvider);
    final clockVisibility = ref.watch(clockVisibilityProvider);
    final bottomVisibility = ref.watch(bottomVisibilityProvider);
    final categoriesVisibility = ref.watch(categoriesVisibilityProvider);
    final appBarVisibility = ref.watch(appBarVisibilityProvider);
    final buttonMicrophone = ref.watch(buttonMicrophoneVisibilityProvider);
    final buttonNewNote = ref.watch(buttonNewNoteVisibilityProvider);

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
                      ref.read(themeNotifierProvider.notifier).toogleDarkMode();
                      ref
                          .read(isDarkmodeProvider.notifier)
                          .update((darkmode) => !darkmode);
                      PreferencesUser()
                          .setValue<bool>('isDarkmode', !isDarkMode);
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
                          .read(customBackground.notifier)
                          .update((customBack) => !customBack);
                      PreferencesUser()
                          .setValue<bool>('customBackground', !customBack);
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
                      PreferencesUser().setValue<bool>(
                          'buttonActionVisibility', !value);
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Vista previa",
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

            const SizedBox(height: 70, child: _ThemeChangerView()),
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

class _ThemeChangerView extends ConsumerWidget {
  const _ThemeChangerView({
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
            ref.read(themeNotifierProvider.notifier).changeColorIndex(index);
            ref.read(selectedColorProvider.notifier).state = index;
            PreferencesUser().setValue<int>('selectedColor', index);
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
