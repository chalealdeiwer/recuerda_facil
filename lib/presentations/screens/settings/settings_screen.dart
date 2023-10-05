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
