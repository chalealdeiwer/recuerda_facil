import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(

            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              // color: Vx.hexToColor("#788154"),
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),

                  radius: 50,
                  backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL.toString()),// Ruta de la imagen
                  // backgroundImage: AssetImage("/assets/images/user.jpg"),
                ),
                const SizedBox(height: 10),
                Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              context.push('/home');
              // Aquí puedes manejar la navegación al inicio de la aplicación
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              context.push('/settings');
              // Aquí puedes manejar la navegación a la configuración de la aplicación
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_arrival_time_outlined),
            title: const Text('Compartir'),
            onTap: () {
              context.push('/shared');
              // Aquí puedes manejar la navegación pa la configuración de la aplicación
            },
          ),
          // Agrega más elementos del Drawer según tus nsecesidades
        ],
      ),
    );
  }
}