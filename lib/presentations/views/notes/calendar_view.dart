import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/presentations/providers/providers.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key});

  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class Event {
  final String title;
  final String content;
  final bool stateDone;
  final String category;
  
  const Event(this.title,this.content,this.stateDone,this.category);

  @override
  String toString() => title;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Event && other.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};
  bool _remindersAdded =
      false; // Nueva variable para rastrear si los recordatorios ya fueron añadidos

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {
      // DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day): [
      //   const Event('Recordatorio de hoy'),
      //   const Event('Recordatorio de hoy 2'),
      //   const Event('Recordatorio de hoy 3'),
      //   const Event('Recordatorio de hoy 4'),
      // ],
      // DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day + 1): [
      //   const Event('Recordatorio de mañana'),
      // ],
      // DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day + 3): [
      //   const Event('Recordatorio en 3 días'),
      // ],
    };
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final userAcc = ref.watch(userProvider);
    final reminder = ref.watch(remindersProvider(userAcc!.uid));
    if (!_remindersAdded) {
      // Comprobación para asegurarse de que los recordatorios se añadan una sola vez
      reminder.whenData((notes) {
        for (var note in notes) {
          var date = note.dateRemember.toUtc();
          var dateKey = DateTime.utc(date.year, date.month, date.day);
          _events.putIfAbsent(dateKey, () => []).add(Event(note.title,note.content,note.stateDone,note.category));
        }
        _remindersAdded = true; // Marcar los recordatorios como añadidos
      });
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
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
            child: TableCalendar(
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mes',
                CalendarFormat.week: 'Semana',
                CalendarFormat.twoWeeks: '2 Semanas',
              },
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

                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.secondary),
                  color: colors.secondary,
                ),
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
                selectedTextStyle: const TextStyle(fontSize: 25,color: Colors.black),
                defaultTextStyle: const TextStyle(fontSize: 22),
                weekendTextStyle: const TextStyle(fontSize: 22),
              ),
              daysOfWeekVisible: true,
              headerVisible: true,
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
          Text(
            "Lista de Recordatorios",
            style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 500,

            child: ListView.builder(
              itemCount: _getEventsForDay(_selectedDay!).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay!)[index];
                return Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colors.surfaceVariant.withOpacity(0.7),

                  ),
                  child: ListTile(
                    onTap: () {
                      
                    },
                    title: Text(event.title),
                    subtitle: SizedBox(
                          height: 50,
                          child: Column(
                            children: [
                              Wrap(
                                alignment: WrapAlignment.start,
                                children: [
                                  Text(event.content, maxLines: 1),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if (event.category != '')
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical:
                                              4.0), // Ajusta el padding según necesites
                                      decoration: BoxDecoration(
                                        color: colors
                                            .surfaceVariant, // Define el color de fondo
                                        borderRadius: BorderRadius.circular(
                                            20), // Define el borderRadius
                                      ),
                                      child: Text(event
                                          .category), // Tu widget Text
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              
                            ],
                          ),
                        ),
                    trailing: const Icon(Icons.event),
                    leading: event.stateDone? const Icon(Icons.done):const Icon(Icons.close),
                
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
