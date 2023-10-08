import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class Event {
  final String title;
  const Event(this.title);
  @override
  String toString() => title;
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;

    _events = {
      DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day): [
        const Event('Recordatorio de hoy')
      ],
      DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day): [
        const Event('Recordatorio de hoy 2')
      ],
      DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day): [
        const Event('Recordatorio de hoy 3')
      ],
      DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day + 1): [
        const Event('Recordatorio de mañana')
      ],
      DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day + 3): [
        const Event('Recordatorio en 3 días')
      ],
    };
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return SingleChildScrollView(
      
      child: Column(
        children: [
          const SizedBox(height: 40,),
          
          Text(
            "Calendario",
            style:
                textStyle.displaySmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors.surfaceVariant.withOpacity(0.7),
            ),
            // Agregado un contenedor para cambiar el color de fondo
            child: TableCalendar(
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mes',
                CalendarFormat.week: 'Semana',
                CalendarFormat.twoWeeks:'2 Semanas'
              },
              daysOfWeekVisible: true,
              headerVisible: true,
        
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: colors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  color: colors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              daysOfWeekHeight: 60,
              headerStyle: const HeaderStyle(
                  formatButtonShowsNext: true,
                  titleTextStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
        
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primary),
                ),
                disabledDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primary),
                ),
                holidayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primary),
                ),
                //puntos marcados
        
                // markerDecoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //   border: Border.all(color: colors.primary),
                // ),
                markerSize: 12,
                // isTodayHighlighted: true
                // outsideDecoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //   border: Border.all(color: colors.error),
                // ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primary),
                ),
                weekNumberTextStyle: const TextStyle(fontSize: 22),
                selectedTextStyle: const TextStyle(fontSize: 25),
                defaultTextStyle: const TextStyle(fontSize: 22),
                weekendTextStyle: const TextStyle(fontSize: 22),
              ),
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
          const SizedBox(
            height: 20,
          ),
          Text(
            "Lista de Recordatorios",
            style: textStyle.headline5,
          ),
          SizedBox(
            height: 100,
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
    );
  }
}
