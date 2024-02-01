import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/features/auth/presentation/providers/providers_auth.dart';
import 'package:recuerda_facil/models/models.dart';
import 'package:recuerda_facil/presentations/providers/notes_provider.dart';
import 'package:recuerda_facil/presentations/screens/more/more_productivity/bar_chart.dart';
import 'package:recuerda_facil/presentations/screens/more/more_productivity/pie_chart.dart';

class ProductivityScreen extends ConsumerStatefulWidget {
  static const name = 'productivity_screen';
  const ProductivityScreen({super.key});

  @override
  ConsumerState<ProductivityScreen> createState() => _ProductivityScreenState();
}

class _ProductivityScreenState extends ConsumerState<ProductivityScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final user = ref.watch(authProvider).user;

    final reminder = ref.watch(remindersProvider(user!.uid!));
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    int reminderCount = reminder.when(
      data: (data) {
        return data.length;
      },
      loading: () {
        return 0;
      },
      error: (error, stackTrace) {
        return 0;
      },
    );
    int incompleteReminderCount = reminder.when(
      data: (data) {
        return data.where((reminder) => !reminder.stateDone).length;
      },
      loading: () {
        return 0;
      },
      error: (error, stackTrace) {
        return 0;
      },
    );

    int completeReminderCount = reminder.when(
      data: (data) {
        return data.where((reminder) => reminder.stateDone).length;
      },
      loading: () {
        return 0;
      },
      error: (error, stackTrace) {
        return 0;
      },
    );
    List<int> daysOfWeek = [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
      DateTime.sunday
    ];

    Map<int, int> reminderCountByDay = {for (var day in daysOfWeek) day: 0};

    reminder.when(
      data: (data) {
        List<Note> incompleteReminders =
            data.where((note) => note.stateDone).toList();

        for (int day in daysOfWeek) {
          int count = incompleteReminders.where((note) {
            return note.dateFinish.weekday == day;
          }).length;

          reminderCountByDay[day] = count;
        }
      },
      loading: () {},
      error: (error, stackTrace) {},
    );

    List<int?> reminderCounts = daysOfWeek.map((day) {
      return reminderCountByDay[day];
    }).toList();
    //categorias

    Map<String, List<Note>> groupedReminders = {};
    Map<String, int> reminderCountMap = {};

    reminder.when(
        data: (data) {
          late Map<String, List<Note>> remindersByCategory;
          for (var reminder in data) {
            if (!groupedReminders.containsKey(reminder.category)) {
              groupedReminders[reminder.category] = [];
            }
            groupedReminders[reminder.category]!.add(reminder);
            remindersByCategory = groupedReminders;
            for (var category in remindersByCategory.keys) {
              var reminders = remindersByCategory[category]!;
              var reminderCount = reminders.length;

              reminderCountMap[category] = reminderCount;
            }
          }
        },
        error: (error, stackTrace) {},
        loading: () {});

    // Map<String, int> getReminderCountMap() {
    //   Map<String, int> reminderCountMap = {};

    //   for (var category in reminders.keys) {
    //     var reminders =reminders[category]!;
    //     var reminderCount = reminders.length;

    //     reminderCountMap[category] = reminderCount;
    //   }

    //   return reminderCountMap;
    // }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Productividad'),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      minRadius: 10,
                      maxRadius: 50,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          Image.network(user.photoURL.toString()).image,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hola, ${user.displayName}',
                            style: textStyle.titleLarge),
                        Text(
                          '(${user.email})',
                          style: textStyle.titleSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Resumen de recordatorios, total: $reminderCount",
                style: textStyle.titleLarge,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: (size.width / 2) - 20,
                  height: 150,
                  decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          completeReminderCount.toString(),
                          style: textStyle.displaySmall,
                        ),
                        Text(
                          'Recordatorios completados',
                          style: textStyle.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: (size.width / 2) - 20,
                  height: 150,
                  decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          incompleteReminderCount.toString(),
                          style: textStyle.displaySmall,
                        ),
                        Text(
                          'Recordatorios pendientes',
                          style: textStyle.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: size.width - 20,
              height: size.height / 2.1,
              decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Finalización de recordatorios por día en General',
                      style: textStyle.titleLarge,
                    ),
                  ),
                  reminderCounts.every((element) => element == 0)
                      ? Center(
                          child: Text(
                            "Aún no hay recordatorios finalizados",
                            style: textStyle.titleLarge!
                                .copyWith(color: colors.error),
                          ),
                        )
                      : BarChartSample7(
                          reminderCounts[0]!,
                          reminderCounts[1]!,
                          reminderCounts[2]!,
                          reminderCounts[3]!,
                          reminderCounts[4]!,
                          reminderCounts[5]!,
                          reminderCounts[6]!,
                        )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: size.width - 20,
              height: size.height / 2,
              decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Clasificación de categorías de todos los recordatorios ',
                      style: textStyle.titleLarge,
                    ),
                  ),
                  reminderCountMap.isEmpty
                      ? Center(
                          child: Text(
                            "Aún no hay recordatorios",
                            style: textStyle.titleLarge!
                                .copyWith(color: colors.error),
                          ),
                        )
                      :
                  PieChartSample2(reminderCountMap: reminderCountMap),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            // Column(
            //   children: daysOfWeek.map((day) {
            //     return Row(
            //       children: [
            //         Text('Día ${day.toString()}: ',
            //             style: TextStyle(fontWeight: FontWeight.bold)),
            //         Text('${reminderCountByDay[day]} recordatorios'),
            //       ],
            //     );
            //   }).toList(),
            // )
          ],
        ));
  }
}
