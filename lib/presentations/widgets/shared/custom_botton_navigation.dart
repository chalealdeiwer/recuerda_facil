import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigation({Key? key, required this.currentIndex}) : super(key: key);

  void onItemTapped(BuildContext context, int index) {
    context.go('/home/$index');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 50),  // Cambia el tamaño del texto aquí
      child: BottomNavigationBar(
        backgroundColor: colors.surfaceVariant.withOpacity(0.5),

        currentIndex: currentIndex,
        onTap: (index) => onItemTapped(context, index),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 60),
            label: "Más",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 60),
            label: "Mi día",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 50),
            label: "Calendario",
          ),
        ],
      ),
    );
  }
}