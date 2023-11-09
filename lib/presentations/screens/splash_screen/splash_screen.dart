import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recuerda_facil/presentations/screens/login/login_2.dart';

import '../../providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
   static const String name = '/splashScreen';
  bool loading;

  SplashScreen({Key? key, this.loading = true}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    _controller.forward(from: 0.0);
    _controller.repeat();
  }

  void stopAnimation() async {
    Future.delayed(const Duration(seconds: 6)).then((value) {
      widget.loading = false;
      if (mounted) {
        setState(() {});
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    startAnimation();
    stopAnimation();

    return user != null
        ? const Login2Screen()
        : _viewSplash(
            size: size,
            animation: _animation,
            colors: colors,
            loading: widget.loading);
  }
}

class _viewSplash extends StatelessWidget {
  var loading;

  _viewSplash({
    required this.size,
    required Animation<double> animation,
    required this.colors,
    required this.loading,
  }) : _animation = animation;

  final Size size;
  final Animation<double> _animation;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFE8EDDB), // Color #e8eddb
              // color: colors.surfaceVariant  ,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 100),
              Stack(
                children: [
                  Positioned(
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 2000),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(
                  flex:
                      50), // Ajusta los valores de flex para cambiar la posición
            ],
          ),
          if (loading)
            Positioned(
                top: size.height * 0.6,
                child: Row(
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: List.generate(50, (index) {
                            return CustomPaint(
                              painter: ArcPainter(
                                radius: _animation.value * (400 + (index * 10)),
                                color: colors.primary
                                    .withOpacity(1 - _animation.value),
                                yOffset: -270,
                              ),
                              size:
                                  Size(150 + (index * 20), 150 + (index * 20)),
                            );
                          }),
                        );
                      },
                    ),
                  ],
                )),
          Positioned(
            top: size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  duration: const Duration(milliseconds: 2000),
                  child: Text(
                    "Recuerda",
                    style: TextStyle(
                        fontFamily: 'SpicyRice-Regular',
                        fontSize: 70,
                        color: colors.primary),
                  ),
                ),
                FadeInLeft(
                  duration: const Duration(milliseconds: 2000),
                  child: Text(
                    "Fácil",
                    style: TextStyle(
                        fontFamily: 'SpicyRice-Regular',
                        fontSize: 60,
                        color: colors.secondary),
                  ),
                ),
              ],
            ),
          ),
          if (loading)
            Positioned(
                bottom: 30,
                child: CircularProgressIndicator(
                  color: colors.primary,
                )),
          if (!loading)
            Positioned(
              bottom: 50,
              child: FilledButton(
                  onPressed: () {
                    context.pushReplacement('/login');
                  },
                  child: const Text("Iniciar",style: TextStyle(fontSize: 30),)),
            )
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double radius;
  final Color color;
  final double yOffset;

  ArcPainter(
      {required this.radius, required this.color, required this.yOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2 + yOffset);

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      0.0,
      pi * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
