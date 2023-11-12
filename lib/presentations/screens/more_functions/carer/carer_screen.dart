
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../models/models.dart';
import '../../../../services/services.dart';

class CarerScreen extends ConsumerStatefulWidget {
  const CarerScreen({super.key});
  static const name = 'carer_screen';

  @override
  ConsumerState<CarerScreen> createState() => _CarerScreenState();
}

class _CarerScreenState extends ConsumerState<CarerScreen> {

  void deleteUser(user,context)async{
    showDialog(context: context, builder: (context) {
      return  AlertDialog(
        title:  const Text("Información"),
        content:   Text("¿Está seguro de que desea eliminar a esta persona?  ${user.displayName}"),
        actions: [
          TextButton(onPressed: (){
            context.pop();
          }, child: const Text("Cancelar")),
          TextButton(onPressed: ()async{
            await removeUserCarer(FirebaseAuth.instance.currentUser!.uid, user.uid).then((value) {
              context.pushReplacement('/carer');
            });


          }, child: const Text("Aceptar")),
        ],
      );
    },);


  }
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size=MediaQuery.of(context).size;
    final user=FirebaseAuth.instance.currentUser;
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Modo Cuidador"),
      ),
      body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              "Personas a cargo",
              style: textStyle.titleLarge,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            FutureBuilder(
              future: getUser(user!.uid), builder: (context, snapshot) {

              if(snapshot.hasData){
                UserAccount userAccount=snapshot.data as UserAccount;
                final List<String>? listUsersCarer=userAccount.usersCarer;
                return Expanded(
              child: FutureBuilder<List<UserAccount>>(


                future: getUsersCarer(listUsersCarer!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay personas a cargo.'));
                  } else {
                    List users = snapshot.data!.toList();

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var user = users[index];
                        String? photoURL = user.photoURL;
                        return ListTile(
                          onTap: () {
                            
                          
                            context.push('/carer_list/${user.uid}');
                          

                          },
                          
                          leading: 
                          CircleAvatar(

                            backgroundColor: colors.surface,
                            backgroundImage: (photoURL == "Sin foto")
                                ? const AssetImage('assets/images/userphoto.png')
                                : NetworkImage(photoURL!) as ImageProvider,
                            onBackgroundImageError: (exception, stackTrace) =>
                                const Icon(Icons.account_circle),

                          ),
                          title: Text(user.displayName ?? 'Sin nombre',style: textStyle.titleLarge,),

                          trailing: IconButton(onPressed: (){
                            deleteUser(user, context);
                          }, icon:const Icon(Icons.delete)),
                              

                          // subtitle: Text(user['email'] ?? 'Sin email'),
                        );
                      },
                    );
                  }
                },
              ),
            ); 

              }else{
                return const Expanded(child:  Center(child: CircularProgressIndicator()));
              }
              

            },),
            
            OutlinedButton(onPressed: (){
              context.push('/add_person_care');

            }, child:
            Text("Añadir Persona",style: textStyle.titleLarge,), ),
            SizedBox(height: size.height*0.5,)
          ],
        )
    );
  }
}
