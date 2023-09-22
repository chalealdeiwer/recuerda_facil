import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recuerda_facil/providers/notes_provider.dart';

class StreamListWidget extends StatefulWidget {
  const StreamListWidget({super.key});

  @override
  State<StreamListWidget> createState() => _StreamListWidgetState();
}


class _StreamListWidgetState extends State<StreamListWidget> {
  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final noteProvider = Provider.of<NoteProvider>(context);
    


    return StreamBuilder<List>(
      stream: noteProvider.getNotesStream(
          FirebaseAuth.instance.currentUser!.uid.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final notes = snapshot.data;
          final notes2=notes;

          
          // final notes2= notes?.where((element) {
          //   return element
          //   ['category']=='Sin Categoría' ;
            
          // },).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await noteProvider.getNotesStream(
                  FirebaseAuth.instance.currentUser!.uid.toString());
            },
            child: ListView.builder(
              itemCount: notes2!.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (direction) async {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      action: SnackBarAction(label: "Aceptar", onPressed: (){
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                    noteProvider.deleteNote(notes2[index]['key']);
                    notes2.removeAt(index);
                  },
                  confirmDismiss: (direction) async {
                    bool result = true;
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
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.green),
                                      onPressed: () {
                                        return Navigator.pop(context, false);
                                      },
                                      child: const Text("Cancelar")),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.red),
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
                    margin:
                        const EdgeInsets.only(left: 5, right: 5, bottom: 2, top: 2),

                    // padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
                    decoration: BoxDecoration(
                        // color:Theme.of(context).colorScheme.secondary.withOpacity(0.20),
                        color: colors.surfaceVariant,
                        
                        borderRadius: BorderRadius.circular(20)),
                    child: 
                    ListTile(
                      leading: const Icon(Icons.notifications_active_outlined,size: 30,),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded,size: 15,),
                        title: Text(
                          notes2[index]['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 30,
                        ),
                        subtitle: 

                          
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.8,
                          height: 60,
                          child: Column(

                            children: [

                              Row(
                                
                                
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(notes2[index]['content'],maxLines: 1  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  // Text(snapshot.data?[index]['user'][0],style: const TextStyle(color: Colors.red),),
                                  Text((notes2[index]['category'])),
                        
                                
                                  Text(notes2[index]['state'])
                                ],
                              ),
                              const SizedBox(height: 23,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('creado: ${(DateFormat('dd/MM/yyyy hh:mm a')
                                      .format(notes2[index]['date_create']))
                                      .toString()}'),
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
                                        ElevatedButton(
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
                                                        textColor: Colors.black,
                                                        label:'¡Ok!'
                                                      , onPressed: (){}),
                                                      duration: const Duration(milliseconds: 1100),
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
                        }

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
