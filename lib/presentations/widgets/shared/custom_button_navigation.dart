import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';

class CustomBottomNavigation extends ConsumerStatefulWidget {
  final int currentIndex;
  const CustomBottomNavigation({super.key, required this.currentIndex});

  @override
  ConsumerState<CustomBottomNavigation> createState() =>
      _CustomBottomNavigationState();
}

class _CustomBottomNavigationState
    extends ConsumerState<CustomBottomNavigation> {
  late FlutterTts flutterTts; // Declara una variable para FlutterTts

  void onItemTapped(BuildContext context, int index) {
    context.go('/home/$index');
  }

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    String viewRouteSpeechText = "";
    final colors = Theme.of(context).colorScheme;
    final ttsButtonsScreen = ref.watch(ttsButtonsScreenProvider);

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 50), // Cambia el tamaño del texto aquí
      child: BottomNavigationBar(
        
        type: BottomNavigationBarType.fixed,
        iconSize: 35,
        selectedFontSize: 25,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedIconTheme: const IconThemeData(size: 45),
        showUnselectedLabels: true,
        unselectedFontSize: 15,
        showSelectedLabels: true,
        backgroundColor: colors.surfaceVariant.withOpacity(0.5),
        currentIndex: widget.currentIndex,
        
        // mouseCursor: MouseCursor.defer,
        onTap: (index) {
          onItemTapped(context, index);
          if (index == 2) {
            ref
                .read(buttonPageChangeProvider.notifier)
                .update((showButton) => false);
          } else if (index == 1) {
            ref
                .read(buttonPageChangeProvider.notifier)
                .update((showButton) => true);
          } else if (index == 0) {
            ref
                .read(buttonPageChangeProvider.notifier)
                .update((showButton) => false);
          }

          if (ttsButtonsScreen) {
            if (index == 2) {
              viewRouteSpeechText = "Pantalla, calendario";
            } else if (index == 1) {
              viewRouteSpeechText = "Pantalla, Mi día";
            } else if (index == 0) {
              viewRouteSpeechText = "Pantalla, más recursos";
            }
            _speak(viewRouteSpeechText);
          }
        },
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Más",
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Mi día",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today,),
            label: "Calendario",
          ),
        ],
      ),
    );
  }
}
