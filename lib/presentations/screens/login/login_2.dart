import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/models/user.dart';
import 'package:recuerda_facil/presentations/screens/screens.dart';
import '../../../services/services.dart';
import '../../providers/providers.dart';

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
      showNotification();

  }

  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final  size = MediaQuery.of(context).size;


    // Usa el método watch directamente dentro del método build
    return user != null ? HomeScreen(pageIndex: 1,) : logiin(user);
  }

  Widget logiin(User? user) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Bienvenido a:",
                      style: TextStyle(
                        fontFamily: 'SpicyRice-Regular',
                        fontSize: 25,
                      )),
                )),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recuerda",
                            style: TextStyle(
                                fontFamily: 'SpicyRice-Regular',
                                fontSize: 65,
                                color: colors.primary),
                          ),
                          Text(
                            "Fácil",
                            style: TextStyle(
                                fontFamily: 'SpicyRice-Regular',
                                fontSize: 60,
                                color: colors.secondary),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: Image.asset(
                          isDarkMode ? "assets/circleLogoWhite.png" : "assets/circleLogo.png",
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  )),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Iniciar Sesión",
                        style: TextStyle(
                          fontFamily: 'SpicyRice-Regular',
                          fontSize: 28,
                        )
                        )
                        )
                        ),
            Offstage(
              offstage: error == '',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
            buildOrLine(),
            buttonGoogle(),
            const Padding(
              padding:  EdgeInsets.symmetric(horizontal:16.0),
              child:  Divider(),
            ),
            newUser(),
            privacy(),

            const SizedBox(height: 100,),

          ],
        ),
      ),
    );
  }

  Widget botonLogin() {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: FilledButton(
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              
              // UserCredential? credenciales = await login(email, password);
              // if (credenciales != null) {
              //   if (credenciales.user != null) {
              //     if (credenciales.user!.emailVerified) {
              //       Navigator.pushAndRemoveUntil(
              //           context,
              //           MaterialPageRoute(builder: (context) => HomeScreen()),
              //           (route) => false);
              //     } else {
              //       setState(() {
              //         error = "Debes verificar tu correo antes de acceder";
              //       });
              //     }
                // }
              // }

            }
          },
          child: const Text("Ingresar",style: TextStyle(fontSize: 25),)),
    );
  }

  Widget privacy(){
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          "Al registrarte aceptas el Tratamiento de Datos y ",
          style: TextStyle(fontSize: 18),
        ),
        TextButton(
            onPressed: () {
              context.push('/privacy');
            },
            child: const Text(
              "Política de Privacidad",
              style: TextStyle(fontSize: 18,color: Colors.blue),
            ))
      ],
    );
  }

  Widget newUser() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      
      children: [
        const Text(
          "¿Nuevo Aquí?",
          style: TextStyle(fontSize: 25),
        ),
        TextButton(
            onPressed: () {
              context.push('/createUser');
            },
            child: const Text(
              "Regístrate",
              style: TextStyle(fontSize: 25),
            ))
      ],
    );
  }

  Widget buildOrLine() {
    return const Padding(
      padding:  EdgeInsets.symmetric(horizontal:16.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: Divider()),
          Text(
            "  ó  ",
            style: TextStyle(fontSize: 30),
          ),
          Expanded(child: Divider())
        ],
      ),
    );
  }

  Widget buttonGoogle() {
    return Column(
      children: [
        SignInButton(
            padding: const EdgeInsets.only(left: 40),
            // mini: true,
            text: "Entrar con Google",
            
            Buttons.Google, onPressed: () async {
          ref.read(userProvider.notifier).signInWithGoogle();
          final user = ref.watch(userProvider);

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
      style: const TextStyle(fontSize: 30) ,
      decoration:  InputDecoration(
          labelText: "Correo",
          labelStyle: const TextStyle(fontSize: 25),
          border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(8),
              borderSide: new BorderSide(color: Colors.black)
              )
              ),
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
      style: const TextStyle(fontSize: 30),
      decoration: InputDecoration(
          labelText: "Contraseña",
          labelStyle: const TextStyle(fontSize: 25),

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
