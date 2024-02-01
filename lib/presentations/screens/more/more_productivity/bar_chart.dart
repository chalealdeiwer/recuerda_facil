import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample7 extends StatefulWidget {
  const BarChartSample7(this.l, this.m, this.mi, this.j, this.v, this.s, this.d,
      {super.key});
  final int l;
  final int m;
  final int mi;
  final int j;
  final int v;
  final int s;
  final int d;

  final shadowColor = const Color(0xFFCCCCCC);

  @override
  State<BarChartSample7> createState() => _BarChartSample7State();
}

class _BarChartSample7State extends State<BarChartSample7> {
  late List<_BarData> dataList;
  @override
  void initState() {
    super.initState();
    dataList = [
      _BarData(Colors.yellow, widget.l.toDouble(), widget.l.toDouble(), "L"),
      _BarData(Colors.green, widget.m.toDouble(), widget.m.toDouble(), "M"),
      _BarData(Colors.orange, widget.mi.toDouble(), widget.mi.toDouble(), "Mi"),
      _BarData(Colors.pink, widget.j.toDouble(), widget.j.toDouble(), "J"),
      _BarData(Colors.blue, widget.v.toDouble(), widget.v.toDouble(), "V"),
      _BarData(Colors.red, widget.s.toDouble(), widget.s.toDouble(), "S"),
      _BarData(Colors.black, widget.d.toDouble(), widget.d.toDouble(), "D"),
    ];
  }

  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
    double shadowValue,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 6,
        ),
        BarChartRodData(
          toY: shadowValue,
          color: widget.shadowColor,
          width: 6,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AspectRatio(
        aspectRatio: 1.4,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            borderData: FlBorderData(
              show: true,
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                drawBelowEverything: true,
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      textAlign: TextAlign.left,
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: _IconWidget(
                        color: dataList[index].color,
                        isSelected: touchedGroupIndex == index,
                        label: dataList[index].label,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.black.withOpacity(0.2),
                strokeWidth: 1,
              ),
            ),
            barGroups: dataList.asMap().entries.map((e) {
              final index = e.key;
              final data = e.value;
              return generateBarGroup(
                index,
                data.color,
                data.value,
                data.shadowValue,
              );
            }).toList(),
            maxY: 30,
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipMargin: 0,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    rod.toY.toString(),
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: rod.color,
                      fontSize: 18,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 12,
                        )
                      ],
                    ),
                  );
                },
              ),
              touchCallback: (event, response) {
                if (event.isInterestedForInteractions &&
                    response != null &&
                    response.spot != null) {
                  setState(() {
                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                  });
                } else {
                  setState(() {
                    touchedGroupIndex = -1;
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.shadowValue, this.label);
  final Color color;
  final double value;
  final double shadowValue;
  final String label;
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
    required this.label,
  }) : super(duration: const Duration(milliseconds: 300));
  final Color color;
  final bool isSelected;
  final String label;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Column(
      children: [
        Transform(
          transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
          origin: const Offset(14, 14),
          child: Icon(
            widget.isSelected ? Icons.face_retouching_natural : Icons.face,
            color: widget.color,
            size: 30,
          ),
        ),
        const SizedBox(height: 5),
        Text(widget.label)
      ],
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}
