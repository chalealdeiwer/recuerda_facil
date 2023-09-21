import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                  backgroundColor: Color.fromARGB(0, 0, 0, 0),

                  radius: 50,
                  backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL.toString()),// Ruta de la imagen
                  // backgroundImage: AssetImage("/assets/images/user.jpg"),
                ),
                SizedBox(height: 10),
                Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              Navigator.of(context).pushNamed('/home');
              // Aquí puedes manejar la navegación al inicio de la aplicación
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              Navigator.of(context).pushNamed('/settings');
              // Aquí puedes manejar la navegación a la configuración de la aplicación
            },
          ),
          ListTile(
            leading: Icon(Icons.share_arrival_time_outlined),
            title: Text('Compartir'),
            onTap: () {
              Navigator.of(context).pushNamed('/shared');
              // Aquí puedes manejar la navegación pa la configuración de la aplicación
            },
          ),
          // Agrega más elementos del Drawer según tus nsecesidades
        ],
      ),
    );
  }
}