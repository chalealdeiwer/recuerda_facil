import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BottonBar extends StatefulWidget {
  const BottonBar({super.key});

  @override
  State<BottonBar> createState() => _BottonBarState();
}

class _BottonBarState extends State<BottonBar> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RoundedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              
              backgroundColor: Vx.hexToColor("#788154"),
              onPressed: () {
                print(FirebaseAuth.instance.currentUser?.uid.toString());

              },child: Icon(Icons.add,color: Colors.white,))
              ,
            const GreenIcon(icon: Icons.mic),
            const GreenIcon(icon: Icons.bookmark_outlined,),
            const GreenIcon(icon: Icons.calendar_today),
            const GreenIcon(icon: Icons.brush),
          ],
        ),
      ).p24(),
    );
  }


}

class GreenIcon extends StatelessWidget {
  const GreenIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    Color greenTouch =Vx.hexToColor("#788154");
    return Icon(
      icon,
      color: greenTouch,
    );
  }
}
class RoundedBox extends StatelessWidget {
  const RoundedBox({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VxBox(child: child).color(Vx.hexToColor("fff6db")).roundedLg.p24.make();
  }
}
