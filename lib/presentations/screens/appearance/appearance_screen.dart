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
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isautodark = true;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final customBack = ref.watch(customBackground);
    final opacity = ref.watch(opacityProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        " Tema de aplicación ",
                        style: textStyle.displaySmall,
                      ),
                      const Expanded(child: Divider())
                    ],
                  ),
                ],
              ),
            ),

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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text("Modo Oscuro"),
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          ref
                              .read(themeNotifierProvider.notifier)
                              .toogleDarkMode();
                          ref
                              .read(isDarkmodeProvider.notifier)
                              .update((darkmode) => !darkmode);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text("Fondo personalizado"),
                      Switch(
                        value: customBack,
                        onChanged: (value) {
                          ref
                              .read(customBackground.notifier)
                              .update((customBack) => !customBack);
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: customBack,
                    child: Row(
                      children: [
                        const Text("Opacidad"),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Vista previa",
                        style: textStyle.titleLarge,
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
                width: size.width * 0.5,
                height: size.height * 0.5,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: IgnorePointer(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: HomeScreen()),
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Color de aplicación"),
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
              context.pop();
            },
            icon: const Icon(Icons.arrow_back)),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         context.pop();
        //       },
        //       icon: const Icon(Icons.save))
        // ],
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