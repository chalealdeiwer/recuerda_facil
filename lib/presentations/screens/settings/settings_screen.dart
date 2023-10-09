import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/screens/home/home_screen.dart';
import 'package:recuerda_facil/services/notification_service.dart';
import 'package:recuerda_facil/services/permissions.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  static const name = 'settings_screen';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final textStyle = Theme.of(context).textTheme;
    final textToSpeech = ref.watch(onTestToSpeechProvider);
    final ttsTitle = ref.watch(ttsTitleProvider);
    final ttsContent = ref.watch(ttsContentProvider);
    final ttsCategory = ref.watch(ttsCategoryProvider);
    final ttsCategorySelector = ref.watch(ttsCategorySelectorProvider);
    final ttsButtonsScreen = ref.watch(ttsButtonsScreenProvider);
    final ttsWelcomeMessage = ref.watch(ttsWelcomeMessageProvider);
    // if(brightness==Brightness.light){
    //  isautodark=false;
    // }
    // else{
    //   isautodark=true;
    // }

    return Scaffold(
      // backgroundColor: Colors.transparent,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Texto a voz",
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
                    const Text("Activar texto a voz"),
                    Switch(
                      value: textToSpeech,
                      onChanged: (textToSpeech) {
                        ref
                            .read(onTestToSpeechProvider.notifier)
                            .update((textToSpeech) => !textToSpeech);
                        ref
                            .read(ttsTitleProvider.notifier)
                            .update((textToSpeech) => true);
                        ref
                            .read(ttsCategoryProvider.notifier)
                            .update((textToSpeech) => false);
                        ref
                            .read(ttsContentProvider.notifier)
                            .update((textToSpeech) => false);
                        ref
                            .read(ttsCategorySelectorProvider.notifier)
                            .update((textToSpeech) => false);

                        ref
                            .read(ttsButtonsScreenProvider.notifier)
                            .update((textToSpeech) => false);
                        ref
                            .read(ttsWelcomeMessageProvider.notifier)
                            .update((textToSpeech) => false);
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible: textToSpeech,
                  child: Column(
                    children: [
                      const Text(
                          "Para activar la lectura mantén presionado el recordatorio"),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text("Título Recordatorio"),
                          Switch(
                            value: ttsTitle,
                            onChanged: (ttsTitle) {
                              ref
                                  .read(ttsTitleProvider.notifier)
                                  .update((ttsTitle) => !ttsTitle);
                            },
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text("Descripción Recordatorio"),
                          Switch(
                            value: ttsContent,
                            onChanged: (ttsContent) {
                              ref
                                  .read(ttsContentProvider.notifier)
                                  .update((ttsContent) => !ttsContent);
                            },
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text("Categoría Recordatorio"),
                          Switch(
                            value: ttsCategory,
                            onChanged: (ttsCategory) {
                              ref
                                  .read(ttsCategoryProvider.notifier)
                                  .update((ttsCategory) => !ttsCategory);
                            },
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text("Categoría Selector"),
                          Switch(
                            value: ttsCategorySelector,
                            onChanged: (ttsCategorySelector) {
                              ref
                                  .read(ttsCategorySelectorProvider.notifier)
                                  .update((ttsCategorySelector) =>
                                      !ttsCategorySelector);
                            },
                          ),
                        ],
                      ),
                      Visibility(
                          visible: ttsCategorySelector,
                          child: const Text(
                              "Se escuchará cada vez que se selecciones una categoría")),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text("Botones de pantalla"),
                          Switch(
                            value: ttsButtonsScreen,
                            onChanged: (ttsButtonsScreen) {
                              ref
                                  .read(ttsButtonsScreenProvider.notifier)
                                  .update(
                                      (ttsButtonsScreen) => !ttsButtonsScreen);
                            },
                          ),
                        ],
                      ),
                      Visibility(
                          visible: ttsButtonsScreen,
                          child: const Text(
                              "Se escuchará cada vez que cambies de pantalla")),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text("Mensaje de bienvenida"),
                          Switch(
                            value: ttsWelcomeMessage,
                            onChanged: (ttsWelcomeMessage) {
                              ref
                                  .read(ttsWelcomeMessageProvider.notifier)
                                  .update((ttsWelcomeMessage) =>
                                      !ttsWelcomeMessage);
                            },
                          ),
                        ],
                      ),
                      Visibility(
                          visible: ttsWelcomeMessage,
                          child: const Text(
                              "Para escuchar, toca el mensaje de bienvenida")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text("Configuraciones"),
      ),
    );
  }
}
