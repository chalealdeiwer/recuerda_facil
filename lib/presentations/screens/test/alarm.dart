import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';

import '../../../services/services.dart';

@pragma('vm:entry-point')
void printHello() {
  // final DateTime now = DateTime.now();
  // final int isolateId = Isolate.current.hashCode;
  // print("[$now] Hola mundo! isolate=$isolateId function='$printHello'");
  showNotification2(3,"Recordar", "Tomar agua todos los días");
}

String alarmTitle = "ay";
String alarmContent = "que rabia parce";

void alarm(int id, Map<String, dynamic> content) {
  // final DateTime now = DateTime.now();
  // final int isolateId = Isolate.current.hashCode;
  // print("[$now] Hola mundo! isolate=$isolateId function='$printHello'");
  showNotification2(5,"hola ${content["0"]}", content["1"]);
  // showNotificationWithImage();
}

void alarm2() {
  showNotification2(5,"Recordatorio", "Un recordatorio esta esperando por ti, entra a la app para verlo");
}
// void programNotification(DateTime targetTime) async {
//   final currentTime = DateTime.now();
//   final initialDuration = targetTime.isBefore(currentTime)
//       ? targetTime.add(Duration(days: 1)).difference(currentTime)
//       : targetTime.difference(currentTime);
//   await AndroidAlarmManager.oneShot(
//     initialDuration,
//     1,
//     primeraAlarma,
//     alarmClock: true,
//     wakeup: true,
//     allowWhileIdle: true,
//     exact: true,
//     rescheduleOnReboot: true,
//   );
// }

class AlarmTest extends StatelessWidget {
  const AlarmTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {

                  alarmTitle = "Hola";
                  alarmContent = "sera que si ??";
                  // await AndroidAlarmManager.periodic(
                  //     const Duration(seconds: 5), helloAlarmID, printHello);
                  await AndroidAlarmManager.oneShot(
                    const Duration(seconds: 10),

                    1,
                    // alarm(15, {"0": "Deiwer", "1": "Chaleal"}),
                    // alarm2,
                    alarmCallback,
                    alarmClock: true,
                    wakeup: true,
                    allowWhileIdle: true,
                    exact: true,
                    rescheduleOnReboot: true,
                  );
                },
                child: const Text("alarma")),
            const DateTimePickerWidget()
          ],
        ),
      ),
    );
  }
}

void alarmCallback() {
  alarm(15, {"0": alarmTitle, "1": alarmContent});
}

class DateTimePickerWidget extends StatefulWidget {
  const DateTimePickerWidget({super.key});

  @override
  DateTimePickerWidgetState createState() => DateTimePickerWidgetState();
}

class DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(
              "${selectedDate.toLocal().toString().split(' ')[0]} ${selectedTime.format(context)}"),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            await _selectDate(context);
            await _selectTime(context);
            // Convirtiendo la fecha y hora seleccionadas en un objeto DateTime
            final DateTime scheduledNotificationDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute);
            programNotification(scheduledNotificationDateTime,); // Pasando la fecha y hora seleccionadas a la función de programación
          },
        ),
      ],
    );
  }
}

void programNotification(
    DateTime targetTime) async {
  
  final initialDuration = targetTime.isBefore(DateTime.now())
      ? targetTime.add(const Duration(days: 1)).difference(DateTime.now())
      : targetTime.difference(DateTime.now());

  await AndroidAlarmManager.oneShot(
    initialDuration,
    1,
    // alarm(3, {"0": "Johna", "1": "Jene"}),
    alarm2,
    alarmClock: true,
    wakeup: true,
    allowWhileIdle: true,
    exact: true,
    rescheduleOnReboot: true,
  );
  // await AndroidAlarmManager.periodic(duration, id, callback)
}
