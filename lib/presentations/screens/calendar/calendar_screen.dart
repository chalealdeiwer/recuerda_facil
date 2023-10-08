import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

class CalendarScreen extends StatefulWidget {
  static const name = 'calendar_screen';
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;

    _events = {
      DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day): [const Event('Recordatorio de hoy')],
      DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day): [const Event('Recordatorio de hoy 2')],
      DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day): [const Event('Recordatorio de hoy 3')],

      DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day + 1): [const Event('Recordatorio de mañana')],
      DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day + 3): [const Event('Recordatorio en 3 días')],
    };
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80,),
            Text("Calendario", style: textStyle.headline4,),
            Container(  // Agregado un contenedor para cambiar el color de fondo
              color: colors.surface,
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: _getEventsForDay,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            const SizedBox(height: 20,),
            Text("Lista de Recordatorios", style: textStyle.headline5,),
            Expanded(
              child: ListView.builder(
                itemCount: _getEventsForDay(_selectedDay!).length,
                itemBuilder: (context, index) {
                  final event = _getEventsForDay(_selectedDay!)[index];
                  return ListTile(
                    title: Text(event.title),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}