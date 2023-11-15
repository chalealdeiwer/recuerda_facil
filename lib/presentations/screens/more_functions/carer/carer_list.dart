import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../config/notes/app_notes.dart';
import '../../../../models/models.dart';
import '../../home/home_screen.dart';

class CarerListStream extends StatelessWidget {
  final String user;
  final String category;
  const CarerListStream({super.key, required this.category, required this.user});
  static const name = 'carer_list_stream';
  @override
  Widget build(BuildContext context) {
      final user2 = GoRouterState.of(context).extra! as UserAccount;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final AppNotes noteProvider = AppNotes();

    return Scaffold(
      
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showNewNote(context, category, user);
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text(
                          "Recordatorios de ${user2.displayName}",
                          style: textStyle.titleLarge,),
            ),
            StreamBuilder<List>(
              stream: noteProvider.getNotesStream(user.toString(), category),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final notes2 = snapshot.data;

                  return SliverList.builder(
                    addAutomaticKeepAlives: true,
                    itemCount: notes2!.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: (direction) async {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            action: SnackBarAction(
                                label: "¡Ok!",
                                textColor: Colors.black,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                }),
                            duration: const Duration(milliseconds: 2000),
                            content: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.delete_forever),
                                Text(
                                  "¡Recordatorio Eliminado!",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.red[200],
                          ));
                          noteProvider.deleteNote(notes2[index].key);

                          notes2.removeAt(index);
                        },
                        confirmDismiss: (direction) async {
                          bool result = true;
                          try {
                            result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: SingleChildScrollView(
                                      child: AlertDialog(
                                        title: Text(
                                            "¿Está seguro de que quiere eliminar ${snapshot.data?[index].title} ?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                return Navigator.pop(
                                                    context, false);
                                              },
                                              child: const Text("Cancelar")),
                                          FilledButton(
                                              onPressed: () {
                                                return Navigator.pop(
                                                    context, true);
                                              },
                                              child: const Text(
                                                  "Si, estoy seguro"))
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
                        key: Key(notes2[index].key),
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 2, top: 2),

                          // padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
                          decoration: BoxDecoration(
                              // color:Theme.of(context).colorScheme.secondary.withOpacity(0.20),
                              color: colors.surfaceVariant.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            leading: Transform.scale(
                              scale: 2,
                              child: Opacity(
                                opacity: 0.7,
                                child: Checkbox(
                                  value: notes2[index].stateDone,
                                  onChanged: (value) async {
                                    if (notes2[index].stateDone == true) {
                                      await noteProvider.updateNoteDateFinish(
                                          notes2[index].key,
                                          DateTime(1, 1, 1, 0, 0));
                                    } else {
                                      await noteProvider.updateNoteDateFinish(
                                          notes2[index].key, DateTime.now());
                                    }
                                    await noteProvider.toggleNoteState(
                                        notes2[index].key, !value!);
                                  },
                                ),
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                            ),
                            title: notes2[index].stateDone == false
                                ? Text(
                                    notes2[index].title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                    maxLines: 30,
                                  )
                                : Text(
                                    notes2[index].title,
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 20,
                                    ),
                                    maxLines: 30,
                                  ),
                            subtitle: SizedBox(
                              // width: MediaQuery.of(context).size.width*0.2,
                              height: 80,
                              child: Column(
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      notes2[index].stateDone == false
                                          ? Text(
                                              notes2[index].content,
                                              maxLines: 1,
                                            
                                            )
                                          :
                                      Text(
                                        notes2[index].content,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      if (notes2[index].category != '')
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical:
                                                  4.0), // Ajusta el padding según necesites
                                          decoration: BoxDecoration(
                                            color: colors
                                                .background, // Define el color de fondo
                                            borderRadius: BorderRadius.circular(
                                                20), // Define el borderRadius
                                          ),
                                          child: Text(notes2[index]
                                              .category), // Tu widget Text
                                        ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    children: [
                                      notes2[index].dateFinish ==
                                              DateTime(1, 1, 1, 0, 0)
                                          ? notes2[index].dateRemember !=
                                                  DateTime(1, 1, 1, 0, 0)
                                                  ? Text(
                                                      'Recordar: ${DateFormat('dd MMM hh:mm a').format(notes2[index].dateRemember)}')
                                                  : 
                                          
                                          const Text(
                                              'Sin fecha para recordar')
                                          : 
                                      notes2[index].dateFinish !=
                                              DateTime(1, 1, 1, 0, 0)
                                          ? Text(
                                              'Finalizado: ${DateFormat('dd MMM hh:mm a').format(notes2[index].dateFinish)}')
                                          : const Text(""),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onLongPress: () {
                              notes2[index].stateDone == true
                                  ? showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Información Recordatorio"),
                                          content: SizedBox(
                                            height: 300,
                                            width: 500,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Creado: ${DateFormat('dd MMM hh:mm a').format(notes2[index].dateCreate)}')
                                                  ],
                                                ),
                                                const Text("Recordatorio"),
                                                Text(notes2[index].title),
                                                const Text(
                                                  "Descripción",
                                                ),
                                                Text(notes2[index].content),
                                                FilledButton(
                                                    onPressed: () async {
                                                      context.pop();
                                                    },
                                                    child:
                                                        const Text("Aceptar"))
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController titleController =
                                            TextEditingController(
                                                text: notes2[index].title);
                                        TextEditingController
                                            contentController =
                                            TextEditingController(
                                                text: notes2[index].content);

                                        return AlertDialog(
                                          title:
                                              const Text("Editar Recordatorio"),
                                          content: SizedBox(
                                            height: 300,
                                            width: 500,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Creado: ${DateFormat('dd MMM hh:mm a').format(notes2[index].dateCreate)}')
                                                  ],
                                                ),
                                                const Text("Recordatorio"),
                                                TextField(
                                                  maxLines: 2,
                                                  controller: titleController,
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
                                                  controller:
                                                      contentController,
                                                  decoration: const InputDecoration(

                                                      // hintText:
                                                      // notes[index]['content'].toString(),
                                                      ),
                                                ),
                                                FilledButton(
                                                    onPressed: () async {
                                                      await noteProvider
                                                          .updateNote(
                                                              notes2[index].key,
                                                              titleController
                                                                  .text,
                                                              contentController
                                                                  .text)
                                                          .then((value) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                                action: SnackBarAction(
                                                                    textColor:
                                                                        Colors
                                                                            .black,
                                                                    label:
                                                                        '¡Ok!',
                                                                    onPressed:
                                                                        () {}),
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            1100),
                                                                backgroundColor:
                                                                    Colors.yellow[
                                                                        200],
                                                                content:
                                                                    const Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Icon(Icons
                                                                        .add_alert_sharp),
                                                                    Text(
                                                                      "¡Recordatorio actualizado!",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                )));
                                                        context.pop();
                                                      });
                                                    },
                                                    child: const Text(
                                                        "Actualizar"))
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const SliverToBoxAdapter(
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator.adaptive(),
                        Text(
                          "Cargando por favor espere",
                          style: TextStyle(fontSize: 30),
                        )
                      ],
                    )),
                  );
                }
              },
            )
          ],
        ));
  }
}
