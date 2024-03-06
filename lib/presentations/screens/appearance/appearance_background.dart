import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recuerda_facil/presentations/providers/appearance_provider2.dart';
import 'package:recuerda_facil/presentations/screens/appearance/backgrounds.dart';
import 'package:recuerda_facil/presentations/screens/home/home_screen.dart';

import '../../../services/services.dart';

class ScreenBackground extends ConsumerStatefulWidget {
  static const String name = 'ScreenBackground';
  const ScreenBackground({super.key});

  @override
  ConsumerState<ScreenBackground> createState() => _ScreenBackgroundState();
}

class _ScreenBackgroundState extends ConsumerState<ScreenBackground> {
  XFile? imageSave;

  @override
  void initState() {
    super.initState();
  }

  void showBackgroundSaved(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fondo Cambiado'),
          content: const Text('El fondo ha sido cambiado correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final opacity = ref.watch(preferencesProvider).opacity;
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar fondo de pantalla'),
        leading: IconButton(
            onPressed: () {
              context.push('/appearance');
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () async {
                      final imagen = await getImage();

                      if (imagen == null) {
                        return;
                      }
                      imageSave = imagen;

                      final Image image = Image.file(File(imagen.path));
                      ref
                          .read(preferencesProvider.notifier)
                          .changeBackground2(image);
                    },
                    child: const Text("Seleccionar Imagen")),
                if (imageSave != null)
                  FilledButton(
                    onPressed: () {
                      ref
                          .read(preferencesProvider.notifier)
                          .changeBackground(imageSave!);
                      showBackgroundSaved(context);
                    },
                    child: const Text("Guardar"),
                  ),
                IconButton(
                    onPressed: () {
                      ref
                          .read(preferencesProvider.notifier)
                          .changeBackgroundDefault();
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            Row(
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
                          .read(preferencesProvider.notifier)
                          .changeOpacity(newValue);
                    },
                  ),
                ),
              ],
            ),

            Center(
              child: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: colors.secondary.withOpacity(0.5))),
                width: size.width * 0.7,
                height: size.height * 0.7,
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
            const SizedBox(
              height: 20,
            ),
            Text(
              "Fondos predefinidos",
              style: textStyle.titleLarge,
            ),
            SizedBox(
              height: 400,
              child: GridView.extent(
                maxCrossAxisExtent: 150,
                padding: const EdgeInsets.all(5),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                children: _imagesList,
              ),
            )

            // SizedBox(
            //   height: 600,
            //   width: double.infinity,
            //   child: imageBackground == null
            //       ? Container(
            //           decoration: const BoxDecoration(
            //             color: Colors.black,
            //             image: DecorationImage(
            //               image:
            //                   AssetImage("assets/backgrounds/background_5.jpg"),
            //               fit: BoxFit
            //                   .cover, // Esto hará que la imagen cubra toda la pantalla
            //             ),
            //           ),
            //         )
            //       : Image.file(
            //           imageBackground!,
            //           fit: BoxFit.cover,
            //         ),
            // ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _imagesList {
    List<Widget> listImages = [];

    for (var image in backgrounds) {
      listImages.add(GestureDetector(
          onTap: () async {
            // Navigator.push(context, MaterialPageRoute(builder: ((context) => ImagePage(url: image))));

            Image imageF = Image.asset(image);
            ref.read(preferencesProvider.notifier).changeBackground2(imageF);
            XFile imageFile = await assetToXFile(image, 'imagen.png');
            ref.read(preferencesProvider.notifier).changeBackground(imageFile);
          },
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          )));
    }

    return listImages;
  }

  Future<XFile> assetToXFile(String assetPath, String fileName) async {
    // Obtener la referencia al archivo de la imagen desde los assets
    ByteData byteData = await rootBundle.load(assetPath);
    List<int> bytes = byteData.buffer.asUint8List();

    // Obtener la ruta del directorio temporal en el dispositivo
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Escribir los bytes de la imagen en un archivo en el directorio temporal
    File file = File('$tempPath/$fileName');
    await file.writeAsBytes(bytes);

    // Crear un XFile con la ruta del archivo temporal
    return XFile(file.path);
  }
}
