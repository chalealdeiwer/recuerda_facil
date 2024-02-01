import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class PieChartSample2 extends StatefulWidget {
  Map<String, int> reminderCountMap;

  PieChartSample2({required this.reminderCountMap, super.key});
  @override
  State<StatefulWidget> createState() => PieChart2State(reminderCountMap);
}

class PieChart2State extends State {
  int touchedIndex = -1;
  Map<String, int> reminderCountMap;
  PieChart2State(this.reminderCountMap);

  @override
  Widget build(BuildContext context) {
    List<String> categories = reminderCountMap.keys.toList();
    List<int> numbers = reminderCountMap.values.toList();
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  sections: showingSections(categories, numbers),
                ),
              ),
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getIndicators(categories, numbers)),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<Widget> getIndicators(List<String> categories, List<int> numbers) {
  List<Widget> indicators = [];

  for (int i = 0; i < categories.length; i++) {
    String categoryText = categories[i].isNotEmpty ? categories[i] : "Sin categoría";
    String countText = "(${numbers[i]})";

    indicators.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Indicator(
            color: getColor(categories[i]),
            text: '$categoryText$countText',
            isSquare: true,
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }

  return indicators;
}

  Color getColor(String category) {
  switch (category) {
    case 'Sin Categoría':
      return Colors.grey; // Color para 'Sin Categoría'
    case 'Salud':
      return Colors.blue;
    case 'Medicamentos':
      return Colors.green;
    case 'Trabajo':
      return Colors.orange;
    case 'Cumpleaños':
      return Colors.red;
    case 'Aniversarios':
      return Colors.purple;
    case 'Personal':
      return Colors.pink;
    default:
      return Colors.grey; // Color por defecto para categorías no especificadas
  }
}

 List<PieChartSectionData> showingSections(List<String> categories, List<int> values) {
  
  List<PieChartSectionData> sections = [];

  for (int i = 0; i < categories.length; i++) {
    final isTouched = i == touchedIndex;
    final fontSize = isTouched ? 20.0 : 10.0;
    final radius = isTouched ? 60.0 : 50.0;
    final percentage = (values[i] / values.reduce((a, b) => a + b)) * 100;

    sections.add(PieChartSectionData(
      color: getColor(categories[i]), // Usamos el método getColor
      value: values[i].toDouble(),
      title: '${percentage.toStringAsFixed(1)}%(${values[i]})', // Calculamos el porcentaje
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
      ),
    ));
  }

  return sections;
}
  
}
