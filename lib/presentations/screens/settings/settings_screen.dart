import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/services/notification_service.dart';
import 'package:recuerda_facil/services/permissions.dart';

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
    final colors = Theme.of(context).colorScheme;
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    Text(
                      "Notificaciones",
                      style: textStyle.titleLarge,
                    ),
                    FilledButton(
                        onPressed: () async {
                          requestNotification().then((value) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                if (value) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Notificaciones',
                                    ),
                                    content: Text(
                                        'Las notificaciones están permitidas.',
                                        style: textStyle.titleLarge),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                } else {
                                  return AlertDialog(
                                    title: const Text('Notificaciones'),
                                    content: Text(
                                        'Las notificaciones están desactivadas.',
                                        style: textStyle.titleLarge),
                                    actions: <Widget>[
                                      FilledButton(
                                        onPressed: () {
                                          context.pop();
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
                          // await showNotification2("Un recordatorio se ha vencido", "Ir a pasear al parque");
                          // await showNotification2("Un recordatorio esta proximo", "Tomar medicina");

                        },
                        child: const Text(
                          "Permitir",
                          style: TextStyle(fontSize: 23),
                        ))
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
                SwitchListTile(
                  title: Text(
                    "Activar texto a voz",
                    style: textStyle.titleLarge,
                  ),
                  value: textToSpeech,
                  onChanged: (value) {
                    final tts = ref
                        .read(onTestToSpeechProvider.notifier)
                        .update((textToSpeech) => !textToSpeech);

                    if (tts) {
                      ref
                          .read(ttsTitleProvider.notifier)
                          .update((textToSpeech) => true);
                      ref
                          .read(ttsCategoryProvider.notifier)
                          .update((textToSpeech) => true);
                      ref
                          .read(ttsContentProvider.notifier)
                          .update((textToSpeech) => true);
                      ref
                          .read(ttsCategorySelectorProvider.notifier)
                          .update((textToSpeech) => true);
                      ref
                          .read(ttsButtonsScreenProvider.notifier)
                          .update((textToSpeech) => true);
                      ref
                          .read(ttsWelcomeMessageProvider.notifier)
                          .update((textToSpeech) => true);
                    } else {
                      ref
                          .read(ttsTitleProvider.notifier)
                          .update((textToSpeech) => false);
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
                    }
                  },
                ),
                Visibility(
                  visible: textToSpeech,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                            "Para activar la lectura toca el recordatorio",
                            style: textStyle.titleLarge!
                                .copyWith(color: colors.error)),
                      ),
                      SwitchListTile(
                        title: Text(
                          "Título Recordatorio",
                          style: textStyle.titleLarge,
                        ),
                        value: ttsTitle,
                        onChanged: (value) {
                          ref
                              .read(ttsTitleProvider.notifier)
                              .update((ttsTitle) => !ttsTitle);
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          "Descripción Recordatorio",
                          style: textStyle.titleLarge,
                        ),
                        value: ttsContent,
                        onChanged: (value) {
                          ref
                              .read(ttsContentProvider.notifier)
                              .update((ttsContent) => !ttsContent);
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          "Categoría Recordatorio",
                          style: textStyle.titleLarge,
                        ),
                        value: ttsCategory,
                        onChanged: (value) {
                          ref
                              .read(ttsCategoryProvider.notifier)
                              .update((ttsCategory) => !ttsCategory);
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          "Categoría Selector",
                          style: textStyle.titleLarge,
                        ),
                        value: ttsCategorySelector,
                        onChanged: (value) {
                          ref.read(ttsCategorySelectorProvider.notifier).update(
                              (ttsCategorySelector) => !ttsCategorySelector);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Visibility(
                            visible: ttsCategorySelector,
                            child: Text(
                                "Se escuchará cada vez que se selecciones una categoría",
                                style: textStyle.titleLarge!
                                    .copyWith(color: colors.error))),
                      ),
                      SwitchListTile(
                        title: Text(
                          "Botones de pantalla",
                          style: textStyle.titleLarge,
                        ),
                        value: ttsButtonsScreen,
                        onChanged: (value) {
                          ref
                              .read(ttsButtonsScreenProvider.notifier)
                              .update((ttsButtonsScreen) => !ttsButtonsScreen);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Visibility(
                            visible: ttsButtonsScreen,
                            child: Text(
                                "Se escuchará cada vez que cambies de pantalla",
                                style: textStyle.titleLarge!
                                    .copyWith(color: colors.error))),
                      ),
                      SwitchListTile(
                        title: Text(
                          "Mensaje de bienvenida",
                          style: textStyle.titleLarge,
                        ),
                        value: ttsWelcomeMessage,
                        onChanged: (value) {
                          ref.read(ttsWelcomeMessageProvider.notifier).update(
                              (ttsWelcomeMessage) => !ttsWelcomeMessage);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Visibility(
                            visible: ttsWelcomeMessage,
                            child: Text(
                                "Para escuchar, toca el mensaje de bienvenida",
                                style: textStyle.titleLarge!
                                    .copyWith(color: colors.error))),
                      ),
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
