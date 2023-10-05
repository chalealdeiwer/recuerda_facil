import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SlideInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlideInfo({required this.title, required this.caption, required this.imageUrl});

}
final slides=<SlideInfo>[
  SlideInfo(title: 'Planea tu día', caption: 'Planifica y gestiona tus actividades con facilidad. Mantén un registro de tus tareas, eventos y recordatorios con facilidad.', imageUrl: 'assets/images/users_guide/planDay.png'),
  SlideInfo(title: 'Agenda tus Actividades', caption: 'Tu agenda de actividades te permite llevar un registro de tus tareas importantes. Nunca te olvides de una cita o evento.', imageUrl: 'assets/images/users_guide/scheduleDay.png'),
  SlideInfo(title: 'Comparte tus recordatorios', caption: 'Comparte recordatorios importantes con tus seres queridos. Mantente conectado y colabora en la organización de eventos y responsabilidades', imageUrl: 'assets/images/users_guide/sharedDay.png'),



];


class UsersGuideScreen extends StatefulWidget {
  static const String name ='tutorial_screen';
  const UsersGuideScreen({super.key});

  @override
  State<UsersGuideScreen> createState() => _UsersGuideScreenState();
}

class _UsersGuideScreenState extends State<UsersGuideScreen> {
  final PageController pageviewController=PageController();
  bool endReached =false;

  @override
  void initState(){
    super.initState();
    pageviewController.addListener(() { 
      final page= pageviewController.page??0;
      if(!endReached &&page>=(slides.length-1.5)){
        
        setState(() {
          endReached=true;
        });
      print('${pageviewController.page}');
      }
    });
  }

  @override
  void dispose() {
    pageviewController.dispose();
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surfaceVariant,

      body: Stack(
        children: [
          PageView(
            controller: pageviewController,
            
            physics:const  BouncingScrollPhysics(),
            children: slides.map((slideData) => _Slide(title: slideData.title, caption: slideData.caption, imageUrl: slideData.imageUrl)).toList(
          ),),

          Positioned(
            right: 20,
            top: 50,
            child: TextButton(onPressed: () {
            
            context.pop();
            
          },
            child: const Text("Salir",style: TextStyle(fontSize: 25),))),

            endReached?
          Positioned(
            bottom: 20,
            right: 30,
            
            child:FadeInRight(
              from: 15,
              delay: const Duration(seconds: 1),
              
              child: FilledButton(onPressed:context.pop 
              , child: const Text("Comenzar",style: TextStyle(fontSize: 25),)),
            ) ):SizedBox()
        ],
      )
    );
  }
}

class _Slide extends StatelessWidget {
  final String title;
  final String caption;
  final String imageUrl;
  const _Slide({super.key, required this.title, required this.caption, required this.imageUrl});

  @override
  Widget build(BuildContext context) {

    final titleStyle=Theme.of(context).textTheme.displaySmall;
    final captionStyle=Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(  image: AssetImage(imageUrl),),
            const SizedBox(height: 20),
            Text(title,style: titleStyle,),
            const SizedBox(height: 10),
            Text(caption,style: captionStyle,)


          ],
        ),
      ),
    );
  }
}