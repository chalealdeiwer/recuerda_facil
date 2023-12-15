import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Importa el paquete

import '../../../features/auth/presentation/providers/providers_auth.dart';

class SlideInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlideInfo(
      {required this.title, required this.caption, required this.imageUrl});
}

final slides = <SlideInfo>[
  SlideInfo(
      title: "Bienvenido(a)",
      caption: "Tu app diseñada para programar recordatorios",
      imageUrl: 'assets/images/users_guide/titleRF.png'),
  SlideInfo(
      title: 'Planea tu día',
      caption:
          'Planifica y gestiona tus actividades con facilidad. Mantén un registro de tus tareas, eventos y recordatorios con facilidad.',
      imageUrl: 'assets/images/users_guide/planDay.png'),
  SlideInfo(
      title: 'Agenda tus Actividades',
      caption:
          'Tu agenda de actividades te permite llevar un registro de tus tareas importantes. Nunca te olvides de una cita o evento.',
      imageUrl: 'assets/images/users_guide/scheduleDay.png'),
  SlideInfo(
      title: 'Comparte tus recordatorios',
      caption:
          'Comparte recordatorios importantes con tus seres queridos. Mantente conectado y colabora en la organización de eventos y responsabilidades',
      imageUrl: 'assets/images/users_guide/sharedDay.png'),

  // Tus slides aquí...
];

class UsersGuideFirstInitScreen extends ConsumerStatefulWidget {
  static const String name = 'tutorial_first_init_screen';

  const UsersGuideFirstInitScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UsersGuideFirstInitScreen> createState() => _UsersGuideScreenState();
}

class _UsersGuideScreenState extends ConsumerState<UsersGuideFirstInitScreen> {
  final PageController pageViewController = PageController();
  bool endReached = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    pageViewController.addListener(() {
      final page = pageViewController.page ?? 0;
      if (!endReached && page >= (slides.length - 1.5)) {
        setState(() {
          endReached = true;
        });
      }
    });
  }

  @override
  void dispose() {
    pageViewController.dispose();
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
            onPageChanged: (value) {
              setState(() {
                index = value;
              });
            },
            controller: pageViewController,
            physics: const BouncingScrollPhysics(),
            children: slides
                .map((slideData) => _Slide(
                    title: slideData.title,
                    caption: slideData.caption,
                    imageUrl: slideData.imageUrl))
                .toList(),
          ),
          Positioned(
            right: 20,
            top: 50,
            child: TextButton(
              onPressed: () {
                ref.read(authProvider.notifier).endFirstInitApp();
              },
              child: const Text(
                "Omitir",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          Positioned(
              bottom: 30,
              left: 50,
              child: GestureDetector(
                  onTap: () {
                    if (index < 3) {
                      pageViewController.animateToPage(index + 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }
                  },
                  child: PageIndicator(
                      currentPage: index, pageCount: slides.length))),
          if (endReached)
            Positioned(
              bottom: 20,
              right: 30,
              child: FadeInRight(
                from: 15,
                delay: const Duration(seconds: 1),
                child: FilledButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).endFirstInitApp();
                  },
                  child: const Text(
                    "Comenzar",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Slide extends StatefulWidget {
  final String title;
  final String caption;
  final String imageUrl;

  const _Slide({
    Key? key,
    required this.title,
    required this.caption,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _SlideState createState() => _SlideState();
}

class _SlideState extends State<_Slide> {
  late FlutterTts flutterTts; // Declara una variable para FlutterTts

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts(); // Inicializa FlutterTts
  }

  Future<void> _speak() async {
    await flutterTts.setLanguage("es-ES"); // Establece el idioma a español
    await flutterTts.speak(
        '${widget.title}. ${widget.caption}'); // Lee el título y el subtítulo
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.displaySmall;
    final captionStyle = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _speak, // Agrega un gesto para activar la lectura
              child: Image(
                image: AssetImage(widget.imageUrl),
              ),
            ),
            const SizedBox(height: 20),
            Text(widget.title,
                style: titleStyle!
                    .copyWith(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(widget.caption, style: captionStyle),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed:
                  _speak, // O podrías agregar un botón para activar la lectura
              child: const Text(
                'Leer en voz alta🔊',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    Key? key,
    required this.currentPage,
    required this.pageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage
                ? colors.primary // Color del punto activo
                : colors.onPrimary, // Color del punto inactivo
          ),
        ),
      ),
    );
  }
}
