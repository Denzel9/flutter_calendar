import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';

class PieChart extends StatefulWidget {
  final double width;
  final double height;

  const PieChart({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<PieChart> createState() => _PieChartState();
}

const completeTask = 10;
const incompleteTask = 5;
const completeSubTask = 23;
const incompleteSubTask = 12;

class _PieChartState extends State<PieChart> {
  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: Chart(
          padding: const EdgeInsets.only(right: 25),
          layers: [
            ChartGroupPieLayer(
              items: [
                [
                  ChartGroupPieDataItem(
                    amount: completeSubTask.toDouble(),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    label: '',
                  ),
                  ChartGroupPieDataItem(
                    amount: incompleteSubTask.toDouble(),
                    color: Colors.amber,
                    label: '',
                  ),
                ],
                [
                  ChartGroupPieDataItem(
                    amount: completeTask.toDouble(),
                    color: Colors.purple,
                    label: '',
                  ),
                  ChartGroupPieDataItem(
                    amount: incompleteTask.toDouble(),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    label: '',
                  ),
                ],
              ],
              settings: const ChartGroupPieSettings(gapSweepAngle: 20),
            )
          ],
        ),
      );
}
