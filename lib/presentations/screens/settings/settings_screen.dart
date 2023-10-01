import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/services/notification_service.dart';
import 'package:recuerda_facil/services/permissions.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  static const name = 'settings_screen';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isautodark = true;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    // if(brightness==Brightness.light){
    //  isautodark=false;
    // }
    // else{
    //   isautodark=true;
    // }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Generales",
                      style: textStyle.displaySmall,
                    ),
                    const Expanded(child: Divider())
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text("Notificaciones"),
                    FilledButton(
                        onPressed: () async {
                          final bool permiso;
                          permiso = await requestNotification().then((value) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                if (value) {
                                  return AlertDialog(
                                    title: const Text('Notificaciones'),
                                    content: const Text(
                                        'Las notificaciones están permitidas.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                } else {
                                  return AlertDialog(
                                    title: const Text('Notificaciones'),
                                    content: const Text(
                                        'Las notificaciones están desactivadas.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                            return value;
                          });
                          await showNotification();
                          // Asumiendo que requestNotification retorna un Future<bool>
                        },
                        child: const Text("Permitir"))
                  ],
                ),
                 Row(
                  children: [
                    Text(" Tema de aplicación ",style: textStyle.displaySmall,),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
              children: [
                const Text("Modo Oscuro"),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    ref.read(themeNotifierProvider.notifier).toogleDarkMode();
                    ref
                        .read(isDarkmodeProvider.notifier)
                        .update((darkmode) => !darkmode);
                  },
                ),
              ],
            ),
          ),

          const Expanded(child: _ThemeChangerView()),
        ],
      ),
      appBar: AppBar(
        title: const Text("Configuraciones"),
      ),
    );
  }
}

class _ThemeChangerView extends ConsumerWidget {
  const _ThemeChangerView({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final List<Color> colors = ref.watch(colorListProvider);
    final selectedIndex = ref.watch(themeNotifierProvider).selectedColor;
    // final int selectedIndex = ref.watch(selectedIndexColorProvider);

    return ListView.builder(
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final Color color = colors[index];
        return RadioListTile(
          title: Text(
            "Color",
            style: TextStyle(color: color),
          ),
          // subtitle: Text("${color.value}"),
          activeColor: color,
          value: index,
          groupValue: selectedIndex,
          onChanged: (value) {
            // ref.read(selectedIndexColorProvider.notifier).state=index;
            ref.read(themeNotifierProvider.notifier).changeColorIndex(index);
          },
        );
      },
    );
  }
}
