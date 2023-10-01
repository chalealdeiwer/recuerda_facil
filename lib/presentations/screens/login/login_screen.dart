import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recuerda_facil/presentations/screens/home/home_screen.dart';
import 'package:recuerda_facil/services/user_services.dart';

class LoginScreen extends StatefulWidget {
  static const  name="login_screen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late String email, password;
  final _formkey = GlobalKey<FormState>();
  String error = '';
  @override
  Widget build(BuildContext context) {
      
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges() , 
      builder:(BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        if(snapshot.connectionState==ConnectionState.active){
          if(snapshot.data==null){
            return logiin();
          }
          else{
            // return LoginPage();
          }
        }
        return HomeScreen();
        // return Scaffold(body: Center(child: CircularProgressIndicator(),));
      } );
    
    
    
    
    
  }

  Widget logiin(){
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
          botonLogin(),
          newUser(),
          buildOrLine(),
          BotonesGoogle()
        ],
      ),
    );
  }

  Widget BotonesGoogle() {
    return Column(
      children: [
        SignInButton(
            padding: const EdgeInsets.only(left: 40),
            // mini: true,
            text: "Entrar con Google",
            Buttons.Google, onPressed: () async {
          await signinGoogle();
          // if (FirebaseAuth.instance.currentUser != null) {
          //   if(await searchUserUid(FirebaseAuth.instance.currentUser!.uid)){
          //     print("el usuario ya esta ene la base de datos");

          //   }else{
          //     // print("se esta agregando a la base de datos");
          //     //   await addUser(FirebaseAuth.instance.currentUser!.displayName.toString(), FirebaseAuth.instance.currentUser!.email.toString(),FirebaseAuth.instance.currentUser!.emailVerified, FirebaseAuth.instance.currentUser!.uid);
          //     //   Navigator.pushAndRemoveUntil(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => HomeScreen()),
          //     //   (Route<dynamic> route) => false);

          //   }

            
          // }
        })
      ],
    );
  }

  Future<UserCredential> signinGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? authentication =await googleUser?.authentication;
    final credentials = GoogleAuthProvider.credential(accessToken: authentication?.accessToken,idToken: authentication?.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credentials);
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

  Widget botonLogin() {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: ElevatedButton(
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              UserCredential? credenciales = await login(email, password);
              if (credenciales != null) {
                if (credenciales.user != null) {
                  if (credenciales.user!.emailVerified) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false);
                  } else {
                    setState(() {
                      error = "Debes verificar tu correo antes de acceder";
                    });
                  }
                }
              }

              
            }
          },
          child: const Text("Login")),
    );
  }

  Future<UserCredential?> login(String email, String passwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          error = "Usuario No encontrado";
        });
      }
      if (e.code == 'wrong-password') {
        setState(() {
          error = "Contraseña Incorrecta";
        });
      }
    }
  }

}

