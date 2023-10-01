import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late DateTime _dateTime;
  late String _greeting;
  late String _mm;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _updateGreeting();
    // Actualizar la hora cada segundo
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {
    //     _dateTime = DateTime.now();
    //     _updateGreeting();
    //   });
    // });
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

    final textStyle = Theme.of(context).textTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      width: MediaQuery.of(context).size.width * 0.97,
      decoration: BoxDecoration(
          color: colors.primary.withOpacity(0.1),
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
    );
  }
}
