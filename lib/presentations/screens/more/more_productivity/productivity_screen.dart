import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/models/models.dart';
import 'package:recuerda_facil/presentations/screens/more/more_productivity/bar_chart.dart';
import 'package:recuerda_facil/presentations/screens/more/more_productivity/pie_chart.dart';

import '../../../providers/providers.dart';

class ProductivityScreen extends ConsumerWidget {
  static const name = 'productivity_screen';
  const ProductivityScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    ref,
  ) {
    final user = ref.watch(userProvider);
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
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
                        maxRadius: 40,
                        child: Image.network(user!.photoURL.toString())),
                    const SizedBox(
                      width: 20,
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
                "Resumen de recordatorios",
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
                          '0',
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
                          '0',
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
              height: size.height / 2.5,
              decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Finalización de recordatorios diarios',
                      style: textStyle.titleLarge,
                    ),
                  ),
                  BarChartSample7()
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
                      'Clasificación de recordatorios sin terminar',
                      style: textStyle.titleLarge,
                    ),
                  ),
                  const PieChartSample2()
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ));
  }
}
