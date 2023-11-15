import 'dart:math';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  static const String name = '/splashScreen';

  const SplashScreen({super.key,}) ;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();

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

    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    startAnimation();

    return  ViewSplash(
            size: size,
            animation: _animation,
            colors: colors,
            );
  }
}

class ViewSplash extends StatelessWidget {
  

  const ViewSplash({
    super.key,
    required this.size,
    required Animation<double> animation,
    required this.colors,
  
  }) : _animation = animation;

  final Size size;
  final Animation<double> _animation;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        
        // alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFFE8EDDB), // Color #e8eddb
              // color: colors.surfaceVariant  ,
            ),
          ),
          //imagen
          Positioned(
            top: size.height * 0.1,
            left: (size.width*0.5)-75,

            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
          ),

          //lineas 
         
            Positioned(
                top: size.height * 0.7,
                left: size.width/2,
                // bottom: 0,
                right: size.width * 0.8,                
                child: AnimatedBuilder(
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
                )),
          //titulo recuerda facil
          Positioned(
            top: size.height * 0.37,
            left: size.width * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recuerda",
                  style: TextStyle(
                      fontFamily: 'SpicyRice-Regular',
                      fontSize: 80,
                      color: colors.primary),
                ),
                Text(
                  "Fácil",
                  style: TextStyle(
                      fontFamily: 'SpicyRice-Regular',
                      fontSize: 70,
                      color: colors.secondary),
                ),
              ],
            ),
          ),
          //botón iniciar
          
            Positioned(
              left: (size.width * 0.5)-16,
                bottom: 30,
                child: CircularProgressIndicator(
                  color: colors.primary,
                )),
          // if (!loading)
          //   Positioned(
          //     left: (size.width * 0.5)-60,
          //     bottom: 50,
          //     child: FilledButton(
          //         onPressed: () {
          //           context.pushReplacement('/login');
          //         },
          //         child: const Text(
          //           "Iniciar",
          //           style: TextStyle(fontSize: 30),
          //         )),
          //   )
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
