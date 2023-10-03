import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:recuerda_facil/config/notes/app_notes.dart';

import '../providers/providers.dart';


class StreamListWidget extends ConsumerStatefulWidget {
  StreamListWidget({super.key});

  @override
  ConsumerState<StreamListWidget> createState() => _StreamListWidgetState();
}

class _StreamListWidgetState extends ConsumerState<StreamListWidget> {
  @override
  void initState() {
    super.initState();
    // if (FirebaseAuth.instance.currentUser != null) {
    //   ref
    //       .read(noteNotifierProvider)
    //       .getNotesStream(FirebaseAuth.instance.currentUser!.uid.toString(),category);
    // }else{
    //   return;
    // }
  }
  @override
  Widget build(BuildContext context) {
     final category = ref.watch(categoryProvider.notifier).state;
final user=ref.watch(userProvider);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final colors = Theme.of(context).colorScheme;
    final textstyle = Theme.of(context).textTheme;
    final AppNotes noteProvider = ref.read(noteNotifierProvider);
    return StreamBuilder<List>(
      stream: noteProvider
          .getNotesStream(user!.uid.toString(),category),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final notes = snapshot.data;
          final notes2;
            notes2= notes?.where((element) {
            return element
            ['category']==category ;

          },).toList();
  
          if (notes2?.length == 0) {
            return Column(
              children: [
                isDarkMode
                    ? Image.asset(
                        "assets/images/notnotesdark.png",
                        height: 200,
                      )
                    : Image.asset(
                        "assets/images/notnotes.png",
                        height: 200,
                      ),
                Center(
                  child: Text(
                    "Aún no hay recordatorios",
                    style: textstyle.titleLarge,
                  ),
                ),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await noteProvider.getNotesStream(
                  FirebaseAuth.instance.currentUser!.uid.toString(),category);
            },
            child: ListView.builder(
              itemCount: notes2!.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (direction) async {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      action: SnackBarAction(
                          label: "¡Ok!",
                          textColor: Colors.black,
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          }),
                      duration: const Duration(milliseconds: 2000),
                      content: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.delete_forever),
                          Text(
                            "¡Recordatorio Eliminado Correctamente!",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.red[200],
                    ));
                    noteProvider.deleteNote(notes2[index]['key']);
                    notes2.removeAt(index);
                  },
                  confirmDismiss: (direction) async {
                    bool result = true;
                    try {
                      result = await showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return Center(
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  title: Text(
                                      "¿Está seguro de que quiere eliminar ${snapshot.data?[index]['title']} ?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          return Navigator.pop(context, false);
                                        },
                                        child: const Text("Cancelar")),
                                    FilledButton(
                                        onPressed: () {
                                          return Navigator.pop(context, true);
                                        },
                                        child: const Text("Si, estoy seguro"))
                                  ],
                                ),
                              ),
                            );
                          });
                      return result;
                    } catch (e) {
                      return false;
                    }
                  },
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red[400],
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete, size: 35),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  key: Key(notes2[index]['key']),
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 5, right: 5, bottom: 2, top: 2),

                    // padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
                    decoration: BoxDecoration(
                        // color:Theme.of(context).colorScheme.secondary.withOpacity(0.20),
                        color: colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                        leading: const Icon(
                          Icons.notifications_active_outlined,
                          size: 30,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                        ),
                        title: Text(
                          notes2[index]['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 30,
                        ),
                        subtitle: SizedBox(
                          // width: MediaQuery.of(context).size.width*0.2,
                          height: 80,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(notes2[index]['content'], maxLines: 1),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  // Text(snapshot.data?[index]['user'][0],style: const TextStyle(color: Colors.red),),
                                  Text((notes2[index]['category'])),

                                  Text(notes2[index]['state'])
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  notes2[index]['date_finish'] !=
                                          notes2[index]['date_create']
                                      ? Text(
                                          'recordar: ${(DateFormat('dd/MM/yyyy hh:mm a').format(notes2[index]['date_finish'])).toString()}')
                                      : Text("iguales"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      'creado: ${(DateFormat('dd/MM/yyyy hh:mm a').format(notes2[index]['date_create'])).toString()}'),
                                ],
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController titlecontrolador =
                                    TextEditingController(
                                        text: notes2[index]['title']);
                                TextEditingController contentcontrolador =
                                    TextEditingController(
                                        text: notes2[index]['content']);

                                return AlertDialog(
                                  title: const Text("Editar Recordatorio"),
                                  content: Container(
                                    height: 300,
                                    width: 500,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Recordatorio"),
                                        TextField(
                                          maxLines: 2,
                                          controller: titlecontrolador,
                                          decoration: const InputDecoration(

                                              // hintText:
                                              // notes[index]['title'].toString(),
                                              ),
                                        ),
                                        const Text(
                                          "Descripción",
                                        ),
                                        TextField(
                                          maxLines: 2,
                                          controller: contentcontrolador,
                                          decoration: const InputDecoration(

                                              // hintText:
                                              // notes[index]['content'].toString(),
                                              ),
                                        ),
                                        FilledButton(
                                            onPressed: () async {
                                              await noteProvider
                                                  .updateNote(
                                                      notes2[index]['key'],
                                                      titlecontrolador.text,
                                                      contentcontrolador.text)
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        action: SnackBarAction(
                                                            textColor:
                                                                Colors.black,
                                                            label: '¡Ok!',
                                                            onPressed: () {}),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    1100),
                                                        backgroundColor:
                                                            Colors.yellow[200],
                                                        content: const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Icon(Icons
                                                                .add_alert_sharp),
                                                            Text(
                                                              "¡Recordatorio actualizado correctamente!",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                        )));
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: const Text("Actualizar"))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        onLongPress: () {
                          
                        },

                        // onTap: () async {

                        //  await Navigator.pushNamed(context, '/edit',arguments: {
                        //     "name": snapshot.data?[index]["name"],
                        //      "uid": snapshot.data?[index]["uid"]
                        //   });
                        //   setState(() {

                        //   });
                        // },
                        ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(),
              Text(
                "Cargando por favor espere",
                style: TextStyle(fontSize: 30),
              )
            ],
          ));
        }
      },
    );
  }
}