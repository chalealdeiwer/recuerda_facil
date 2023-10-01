import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/config/notes/app_notes.dart';
import 'package:recuerda_facil/models/user_account.dart';
import 'package:recuerda_facil/presentations/providers/notes_provider2.dart';
import 'package:recuerda_facil/services/user_services.dart';

import '../../providers/user_provider.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  static const name = 'community_screen';
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _TestScreenState();
}

  

class _TestScreenState extends ConsumerState<CommunityScreen> {

  
  
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final userActive = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personas'),
      ),
      body: Column(
        
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.01,),
          const Text("Encuentra personas que son parte de Recuerda Fácil"),
          SizedBox(height: MediaQuery.of(context).size.height*0.01,),
          Expanded(
            child: FutureBuilder<List<UserAccount>>(
            future: getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay usuarios disponibles.'));
              } else {
                List users = snapshot.data!.where((element){
                  return element.private==false;
                }).toList();
          
                return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  String? photoURL = user.photoURL;
                  return ListTile(
                    
                    leading: CircleAvatar(
                      // radius: 0,
                      backgroundColor: colors.surface,
                      backgroundImage: (photoURL =="Sin foto")
                          ? AssetImage('assets/images/userphoto.png')
                          : NetworkImage(photoURL!) as ImageProvider,
                      onBackgroundImageError: (exception, stackTrace) => Icon(Icons.account_circle),
                    ),
                    title: Text(user.displayName?? 'Sin nombre'),
                    
                    subtitle: (user.uid==userActive!.uid.toString())?Text("Tú (${user.email})" ?? 'Sin email'):const Text(""),
                    
                    // subtitle: Text(user['email'] ?? 'Sin email'),
                  );
                },
              );
          
          
              }
            },
            ),
          ),
        ],
      )
    );
    
  }
}