import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/screens/home/home_screen.dart';

class CreateUserScreen extends StatefulWidget {
  static const  name="create_user_screen";

  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => CreateUserScreenState();
}

class CreateUserScreenState extends State<CreateUserScreen> {

  late String email, password;
  final _formkey = GlobalKey<FormState>();
  String error='';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Creación de Usuario",style: TextStyle(
               fontSize: 30, fontWeight: FontWeight.bold 
            ) ,),
          ),
          Offstage(
            offstage: error=='',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(error,style: TextStyle(
                color: Colors.red,fontSize: 16
              ),),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
          child: formulario(),),
          butonCreate(),

          
        ],

      ),
      );
  }
  Widget formulario(){
    return Form(
      key: _formkey,
      child:  Column(
      children: [
        builEmail(),
        const Padding(padding: EdgeInsets.only(top: 12)),
          builPassword()
      ],
    ));
  }

  Widget builEmail(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Corrreo",
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8),
          borderSide: new BorderSide(color: Colors.black)
        )
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if(value!.isEmpty){
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value){
        email=value!;
      },
    );
  }
  Widget builPassword(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8),
          borderSide: new BorderSide(color: Colors.black)
        )
      ),
      obscureText: true,
      validator: (value){
        if(value!.isEmpty){
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value){
        password=value!;
      },
    );


  }

  Widget butonCreate(){
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: ElevatedButton(onPressed: ()async{
        if(_formkey.currentState!.validate()){
          _formkey.currentState!.save();
          UserCredential? credenciales = await crear(email, password);
          if(credenciales !=null){
            await credenciales.user!.sendEmailVerification();
            await FirebaseAuth.instance.signOut();
            context.pop();
            
          }


        }else{
            error="No se ha creado la cuenta, formato no válido";
          }

        
        
      }, child:const Text("Crear") ),
    );
  }

  Future<UserCredential?> crear(String email, String passwd) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e){
      if(e.code=='email-already-in-use'){
        setState(() {
          
          error= "El correo ya se encuentra en uso";

        });

      }else{
        if(e.code== 'weak-password'){
         setState(() {
          
          error= "Contraseña débil";

        });
      }

      }
      
    }

  }
}