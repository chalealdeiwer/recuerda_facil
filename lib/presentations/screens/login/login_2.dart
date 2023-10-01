import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/models/user.dart';
import 'package:recuerda_facil/presentations/providers/user_provider.dart';
import 'package:recuerda_facil/presentations/screens/screens.dart';
import 'package:recuerda_facil/services/user_services.dart';

class Login2Screen extends ConsumerStatefulWidget {
  static const name = "login_screen";

  const Login2Screen({Key? key}) : super(key: key);

  @override
  ConsumerState<Login2Screen> createState() => _Login2ScreenState();
}

class _Login2ScreenState extends ConsumerState<Login2Screen> {
  @override
  late String email, password;
  final _formkey = GlobalKey<FormState>();
  String error = '';
  @override
  void initState() {
    super.initState();
    
  }
  

  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    // Usa el método watch directamente dentro del método build
    return user != null ? HomeScreen() : logiin(user);


  }


  Widget logiin(User? user){
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding:  EdgeInsets.all(16.0),
            child: Text(
              "Recuerda Fácil",
              style: TextStyle( fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
          width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Iniciar Sesión",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            )
          ),
          Offstage(
            offstage: error == '',
            child: Padding(
              padding:  const EdgeInsets.all(8.0),
              child: Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: formulario(),
          ),
          // botonLogin(),
          newUser(),
          buildOrLine(),
          buttonGoogle()
        ],
      ),
    );
  }
  // Widget botonLogin() {
  //   return FractionallySizedBox(
  //     widthFactor: 0.6,
  //     child: ElevatedButton(
  //         onPressed: () async {
  //           if (_formkey.currentState!.validate()) {
  //             _formkey.currentState!.save();
  //             UserCredential? credenciales = await login(email, password);
  //             if (credenciales != null) {
  //               if (credenciales.user != null) {
  //                 if (credenciales.user!.emailVerified) {
  //                   Navigator.pushAndRemoveUntil(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => HomeScreen()),
  //                       (route) => false);
  //                 } else {
  //                   setState(() {
  //                     error = "Debes verificar tu correo antes de acceder";
  //                   });
  //                 }
  //               }
  //             }

              
  //           }
  //         },
  //         child: const Text("Login")),
  //   );
  // }


   Widget newUser() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("¿Nuevo Aquí?"),
        TextButton(
            onPressed: () {
              context.push('/createUser');
            },
            child: const Text("Registrarse"))
      ],
    );
  }
  Widget buildOrLine() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: Divider()),
        Text("  ó  "),
        Expanded(child: Divider())
      ],
    );
  }
  Widget buttonGoogle() {
    return Column(
      children: [
        SignInButton(
            padding: const EdgeInsets.only(left: 40),
            // mini: true,
            text: "Entrar con Google",
            Buttons.Google, onPressed: ()async {
              
             ref.read(userProvider.notifier).signInWithGoogle();
             final user =  ref.watch(userProvider);


          // if (user!= null) {
          //   if( await searchUserUid(user.uid)){
          //     print("el usuario ya esta ene la base de datos");

          //   }else{
          //     print("el usuario se esta agregando a la base de datos");
          //         addUser(user.displayName.toString(), user.email.toString(),user.emailVerified, user.uid,user.photoURL.toString());
          //       // Navigator.pushAndRemoveUntil(
          //       // context,
          //       // MaterialPageRoute(builder: (context) => HomeScreen()),
          //       // (Route<dynamic> route) => false);

          //   }

            
          // }
        })
      ],
    );
  }
  Widget formulario() {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            builEmail(),
            const Padding(padding: EdgeInsets.only(top: 12)),
            builPassword()
          ],
        ));
  }
  Widget builEmail() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Correo",
          border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(8),
              borderSide: new BorderSide(color: Colors.black))),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
        email = value!;
      },
    );
  }
  Widget builPassword() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Contraseña",
          border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(8),
              borderSide: new BorderSide(color: Colors.black))),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
        password = value!;
      },
    );
  }


}