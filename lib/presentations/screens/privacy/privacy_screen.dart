import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/services.dart';
import '../../providers/providers.dart';

class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});
  static const name = 'privacy_screen';


  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: textStyle.titleLarge!.fontSize);
    final TextStyle textStyle2 = TextStyle(fontSize: 22);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Tratamiento de Datos Y Privacidad ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: textStyle.titleLarge!.fontSize),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    isDarkMode ? "assets/circleLogoWhite.png" : "assets/circleLogo.png",
                    height: 90,
                  ),
                  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recuerda",
                            style: TextStyle(
                                fontFamily: 'SpicyRice-Regular',
                                fontSize: 30,
                                color: colors.primary),
                          ),
                          Text(
                            "Fácil",
                            style: TextStyle(
                                fontFamily: 'SpicyRice-Regular',
                                fontSize: 25,
                                color: colors.secondary),
                          ),
                        ],
                      ),
                  Image.asset(
                    isDarkMode ? "assets/udenarwhite.png" : "assets/udenar.png",
                    height: 110,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  height: size.height * 2.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. Introducción", style: titleStyle),
                        Text(
                          """Esta Declaración de Tratamiento de Datos y Privacidad explica cómo "Recuerda Fácil", un proyecto de grado de la Universidad de Nariño, maneja la información personal de los usuarios. 
Estamos comprometidos a proteger tu privacidad conforme a la Ley 1581 de 2012 y su decreto reglamentario en Colombia.""",
                          style: textStyle2,
                        ),
                        Text("2.Responsable del Tratamiento de Datos",
                            style: titleStyle),
                        Text(
                          """"Recuerda Fácil" es el encargado de gestionar los datos personales recogidos a través de nuestra aplicación.""",
                          style: textStyle2,
                        ),
                        Text("3.Finalidad del Tratamiento de Datos",
                            style: titleStyle),
                        Text(
                          """Usamos los datos personales para ofrecerte una experiencia personalizada, facilitando a los adultos mayores la programación y recordatorio de actividades especiales.""",
                          style: textStyle2,
                        ),
                        Text(
                          "4.Datos Personales Recopilados ",
                          style: titleStyle,
                        ),
                        Text(
                          """Recopilamos información como nombre, dirección de correo electrónico y número de teléfono. Explicamos claramente cómo y por qué se utilizan estos datos para garantizar la transparencia.""",
                          style: textStyle2,
                        ),
                        Text(
                          "5.Consentimiento del Usuario ",
                          style: titleStyle,
                        ),
                        Text(
                          """Tu consentimiento se solicitará explícitamente. Tendrás la opción de revocarlo en cualquier momento, accediendo a las configuraciones de la aplicación.""",
                          style: textStyle2,
                        ),
                        Text(
                          "6.Uso de los Datos Personales",
                          style: titleStyle,
                        ),
                        Text(
                          """Tus datos permiten la programación y recordatorio de actividades, el envío de notificaciones relacionadas y la mejora continua de la aplicación.""",
                          style: textStyle2,
                        ),
                        Text(
                          "7.Cambios en la Declaración de Privacidad",
                          style: titleStyle,
                        ),
                        Text(
                          """Te notificaremos sobre cualquier cambio en esta política para asegurarnos de que siempre estás informado sobre cómo se manejan tus datos.""",
                          style: textStyle2,
                        ),
                        Text(
                          "8.Contacto ",
                          style: titleStyle,
                        ),
                        Text(
                          """Para consultas sobre privacidad, contáctenos en: """,
                          style: textStyle2,
                        ),
                        GestureDetector(
                          onTap: () {
                            launchEmailPrivacy('recuerdafacil2024@gmail.com');
                            // _launchUrl();
                          },

                          
                          child:const Text("recuerdafacil2024@gmail.com",style: TextStyle(fontSize: 22,color: Colors.blue,),)),
                        Text(
                          "9.Ley Aplicable y Jurisdicción ",
                          style: titleStyle,
                        ),
                        Text(
                          """Esta política se rige por las leyes colombianas y cualquier disputa se someterá a la jurisdicción de los tribunales de Colombia.""",
                          style: textStyle2,
                        ),
                        Text(
                          "10.Fecha de la Declaración de Privacidad ",
                          style: titleStyle,
                        ),
                        Text(
                          """Última actualización: 1 de septiembre de 2023.""",
                          style: textStyle2,
                        ),
                        Text(
                          "Aceptación del Usuario",
                          style: titleStyle,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {
                                value = !value!;
                              },
                            ),
                            Text(
                              """ Acepto la Declaración de 
 Tratamiento de Datos 
 3D Privacidad.""",
                              style: textStyle2,
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

