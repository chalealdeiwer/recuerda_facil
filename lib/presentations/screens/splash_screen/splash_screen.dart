import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/inicio.jpg',
              fit: BoxFit.contain,
            ),
          ),
          Column(
            children: [
              const Spacer(
                  flex:
                      550), // Ajusta los valores de flex para cambiar la posición
              Image.asset(
                'assets/logo.png',
                width: 120,
              ),
              const Spacer(
                  flex:
                      190), // Ajusta los valores de flex para cambiar la posición
              ElevatedButton(
                onPressed: () {
                  startAnimation();
                },
                child: const Text('Iniciar Sesión'),
              ),
              const Spacer(
                  flex:
                      1), // Ajusta los valores de flex para cambiar la posición
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: List.generate(5, (index) {
                      return CustomPaint(
                        painter: ArcPainter(
                          radius: _animation.value * (75 + (index * 10)),
                          color: Colors.green.withOpacity(1 - _animation.value),
                          yOffset: -270,
                        ),
                        size: Size(150 + (index * 20), 150 + (index * 20)),
                      );
                    }),
                  );
                },
              ),
              const Spacer(
                  flex:
                      50), // Ajusta los valores de flex para cambiar la posición
            ],
          ),
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
      ..strokeWidth = 4.0;

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