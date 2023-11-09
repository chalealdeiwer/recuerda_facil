import 'package:flutter/material.dart';
import 'package:recuerda_facil/services/services.dart';

class ContactInfoScreen extends StatelessWidget {
  const ContactInfoScreen({super.key});
  static const name = 'contact_info_screen';

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
                      Icons.account_circle_rounded,
                      size: 100,
                    ),
            Center(
                child: Text(
              "Información de contacto",
              style: textStyle.displaySmall,
            )),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: colors.surfaceVariant

                  
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "  Correo electrónico de soporte",
                      style: textStyle.titleLarge,
                    ),
                    TextButton(
                        onPressed: () {
                          launchEmailSupport('recuerdafacil2024@gmail.com');
                        },
                        child: const Text(
                          "recuerdafacil2024@gmail.com",
                          style: TextStyle(fontSize: 20),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "   Contactos llamadas:",
                      style: textStyle.titleLarge,
                    ),
                    Row(children: [
                      TextButton.icon(
                        onPressed: () {
                          launchPhone("+573158179455");
                        },
                        label: const Text(
                          "3158179455",
                          style: TextStyle(fontSize: 20),
                        ),
                        icon: const Icon(Icons.phone),
                      ),
                      TextButton.icon(
                          icon: const Icon(Icons.phone),
                          onPressed: () {
                            launchPhone("+573114516306");
                          },
                          label: const Text(
                            "3114516306",
                            style: TextStyle(fontSize: 20),
                          ))
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "   WhatsApp:",
                      style: textStyle.titleLarge,
                    ),
                    Row(children: [
                      TextButton.icon(
                        onPressed: () {
                          launchWhatsApp("+573158179455",
                              "Hola, quisiera obtener información acerca de: ...");
                        },
                        label: const Text(
                          "3158179455",
                          style: TextStyle(fontSize: 20),
                        ),
                        icon: const Icon(Icons.message_rounded),
                      ),
                      TextButton.icon(
                          icon: const Icon(Icons.message_rounded),
                          onPressed: () {
                            launchWhatsApp("+573114516306",
                                "Hola, quisiera obtener información acerca de: ...");
                          },
                          label: const Text(
                            "3114516306",
                            style: TextStyle(fontSize: 20),
                          ))
                    ]),
                    SizedBox(
                      height: size.height * 0.25,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Recuerda fácil",
                            style: textStyle.titleLarge,
                          ),
                          Text(
                            "Horarios de atención",
                            style: textStyle.titleLarge,
                          ),
                          Text(
                            "Lunes a Viernes",
                            style: textStyle.titleLarge,
                          ),
                          Text(
                            "8:00 am - 5:00 pm",
                            style: textStyle.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
