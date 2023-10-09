import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart';

class ClockWidget extends ConsumerStatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends ConsumerState<ClockWidget> {
  late DateTime _dateTime;
  late String _greeting;
  late String _mm;
  late FlutterTts flutterTts; // Declara una variable para FlutterTts


  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _dateTime = DateTime.now();
    _updateGreeting();
    // Actualizar la hora cada segundo
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _dateTime = DateTime.now();
        _updateGreeting();
      });
    });
  }
   Future<void> _speak(String text) async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.speak(text);
  }

  void _updateGreeting() {
    // Obtener la hora actual y determinar el saludo correspondiente
    int hour = _dateTime.hour;
    if (hour < 12) {
      _greeting = ' ¡BUENOS DÍAS!';
      _mm = "am";
    } else if (hour < 18) {
      _greeting = ' ¡BUENAS TARDES!';
      _mm = "pm";
    } else {
      _greeting = ' ¡BUENAS NOCHES!';
      _mm = "pm";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    var formatoDia = DateFormat('EEEE', 'es').format(_dateTime);
    formatoDia = formatoDia[0].toUpperCase() + formatoDia.substring(1);
    var dia = DateFormat.d('es').format(_dateTime);
    var mes = DateFormat.MMMM('es').format(_dateTime);
    mes = mes[0].toUpperCase() + mes.substring(1);
    var ano= DateFormat.y('es').format(_dateTime);
    String time = DateFormat('h:mm').format(_dateTime);
    final opacity=ref.watch(opacityProvider);
    final textStyle = Theme.of(context).textTheme;
    final ttsWelcomeMessage = ref.watch(ttsWelcomeMessageProvider);

    return GestureDetector(
      onTap: () {
        if(ttsWelcomeMessage) {
          _speak("$_greeting. $time $_mm $formatoDia, $dia de $mes de $ano");
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.18,
        width: MediaQuery.of(context).size.width * 0.97,
        decoration: BoxDecoration(
            color: colors.surfaceVariant.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20)),
        //  alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 1,
              ),
              Text(
                _greeting,
                style: textStyle.displaySmall,
                //  textAlign: TextAlign.left,
              ),
              Text(
                " $time $_mm $formatoDia, $dia de $mes de $ano",
                style: const TextStyle(fontSize: 25),
                // textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
