import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/providers/providers.dart';
import 'package:recuerda_facil/services/user_services.dart';

import '../providers/user_account_provider.dart';

class CategorySelector extends ConsumerWidget {
  





  @override
  Widget build(BuildContext context,ref) {
    final user = ref.watch(userProvider);
    final userAcc = ref.watch(userProviderr(user!.uid));
    final List<String> categories;
    categories = userAcc.when(
      data: (data) {
        return data!.categories!;
      },
      error: (error, stackTrace) {
        return [];
      },
      loading: () {
        return [];
      },
    );
    int selectedIndex = ref.watch(indexCategoryProvider.notifier).state;

    final colors = Theme.of(context).colorScheme;
    final _controller = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length + 1,
      itemBuilder: (BuildContext context, int index) {

        if (index == categories.length) {
          return IconButton(
            onPressed: () async {
              // Mostrar un cuadro de diálogo al presionar el botón
              showDialog(
                context: context,
                builder: (context) {
                  // Variable para almacenar el nombre de la nueva categoría
                  return AlertDialog(
                    title: const Text('Agregar nueva categoría'),
                    content: Form(
                      key:
                          _formKey, // Asegúrate de inicializar esta clave en tu clase de estado
                      child: TextFormField(
                        maxLength: 30,
                        controller:
                            _controller, // Controlador para manejar el texto ingresado
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, introduce una categoría';
                          } else if (categories.contains(value)) {
                            return 'Esta categoría ya existe';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Nombre de la nueva categoría',
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      FilledButton(
                        child: const Text('Agregar'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Verificar si pasa las validaciones
                            await addUserCategory(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    _controller.text)
                                .then((value) {
                              context.pop();
                            });
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.add_box,
              color: colors.primary,
            ),
          );
        }
        


        return Row(
          children: [
            GestureDetector(
              onTap: () {
                selectedIndex = index;

                ref
                    .watch(categoryProvider.notifier)
                    .update((state) => categories[index]);
                ref
                    .watch(indexCategoryProvider.notifier)
                    .update((state) => index);
              },
              onLongPress: () {
                selectedIndex = index;

                ref
                    .watch(categoryProvider.notifier)
                    .update((state) => categories[index]);
                ref
                    .watch(indexCategoryProvider.notifier)
                    .update((state) => index);
                // Verificar si la categoría seleccionada es "Sin Categoría"
                if (categories[index] != "Sin Categoría") {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Eliminar Categoría'),
                        content: const Text(
                            '¿Estás seguro de que quieres eliminar esta categoría? Los recordatorios de esta categoría pasarán a "Sin Categoría"'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              context.pop(); // Cerrar el cuadro de diálogo
                            },
                          ),
                          FilledButton(
                            // Por favor verifica este widget, no es estándar en Flutter y podría causar un error
                            child: const Text('Eliminar'),
                            onPressed: () async {
                              await removeUserCategory(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      categories[index])
                                  .then((value) {
                                context.pop();
                              });
                              // Recargar las categorías o actualizar la UI como sea necesario
                              //  await _loadCategories().then((value) =>{
                              //   if(mounted)
                              //  setState(() {}),

                              //   context.pop()
                              //  });
                              // Cerrar el cuadro de diálogo
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Acción no permitida'),
                        content:
                            const Text('Esta categoría no se puede eliminar'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Entendido'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Cerrar el cuadro de diálogo
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: index == selectedIndex
                      ? colors.primary.withOpacity(0.4)
                      : colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      categories[index],
                      style: TextStyle(
                          color: index == selectedIndex
                              ? colors.primary
                              : colors.secondary.withOpacity(0.5),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          // decoration: index == selectedIndex
                          //     ? TextDecoration.underline
                          //     : null,
                          decorationColor: colors.primary),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        );
      },
    );
  }
}


