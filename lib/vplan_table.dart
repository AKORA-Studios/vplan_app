// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:vplan_app/json/vplan.dart';

class vPlanTable extends StatefulWidget {
  const vPlanTable({Key? key, required this.url}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String url;

  @override
  State<vPlanTable> createState() => _vPlanTableState();
}

class _vPlanTableState extends State<vPlanTable> {
  VPlan? plan;

  Future<void> _loadVPlan() async {
    VPlan tmp = await downloadVPlanURL(widget.url);

    setState(() {
      plan = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (plan == null) {
      _loadVPlan();
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    String title = plan!.head.title;
    String subtitle = plan!.head.created;

    List<DataRow> rows = [];
    for (var entry in plan!.body) {
      rows.add(DataRow(cells: <DataCell>[
        DataCell(Text(entry.bodyClass)),
        DataCell(Text(entry.lesson)),
        DataCell(Text(entry.subject)),
        DataCell(Text(entry.teacher)),
        DataCell(Text(entry.room)),
        DataCell(SingleChildScrollView(child: Text(entry.info)))
      ]));
    }

    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(title),
                Text("Letzte Änderung am: $subtitle"),
                DataTable(
                  columnSpacing: 10,
                  columns: const <DataColumn>[
                    DataColumn(label: Text("Klasse")),
                    DataColumn(label: Text("S")),
                    DataColumn(label: Text("Fach")),
                    DataColumn(label: Text("Lehrer")),
                    DataColumn(label: Text("Raum")),
                    DataColumn(label: Text("Info"))
                  ],
                  rows: rows,
                ),
                // This trailing comma makes auto-formatting nicer for build methods.
              ],
            )));
  }
}
