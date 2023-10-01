
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../services/select_image.dart';
import '../../../services/upload_image.dart';

class MoreScreen extends StatefulWidget {
  static const name = 'more_screen';
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  

  File? imagen_to_upload;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: AppBar(
        title: const Text("Subir Imagenes"),
      ),
      body: Column(
        children: [

          imagen_to_upload != null? Image.file(imagen_to_upload!,fit: BoxFit.cover,) :
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            color: Colors.red,
          
          ),
          ElevatedButton(onPressed: ()async{
            final imagen = await getImage();
            setState(() {
              
              imagen_to_upload = File(imagen!.path);
            });
          
          }, child: const Text(
            "Seleccionar Imagen"
          )),
          ElevatedButton(onPressed: ()async{
            if(imagen_to_upload ==null){
              return;
            }else{

              // final uploader= await uploadImage(imagen_to_upload!);
              
              // if(uploader){
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text("Imagen subida correctamente"))
              //   );

              // }else{
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text("Error al subir imagen"))
              //   );

              // }

            }

          }, child: const Text(
            "Subir Imagen"
          )),

        ],
      ),
    );
  }
}