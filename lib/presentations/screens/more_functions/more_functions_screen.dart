import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoreFunctionsScreen extends StatelessWidget {
  static const name = 'more_functions_screen';
  const MoreFunctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Más funciones"),
      ),
      body: Center(child: 
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap:() {
                context.push('/carer');
              }, 
              child: Container(
                height: size.height*0.4,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colors.surfaceVariant,
            
                ),
                child:  Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Ser Cuidador",style: textStyle.displaySmall,textAlign: TextAlign.center,),
                    Image.asset("assets/images/carer_2.png",height: 200,),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap:() {
                context.push('/set_carer');
              }, 
              child: Container(
                height: size.height*0.4,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colors.surfaceVariant,
            
                ),
                child:  Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text("O Asignar Cuidador",style: textStyle.displaySmall,textAlign: TextAlign.center,),
                    Image.asset("assets/images/carer.png",height: 200,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),),

    )
    ;
  }
}