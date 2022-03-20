// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vplan_app/json/vplan.dart';
import 'package:vplan_app/vplan_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "VPlan",
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'VPlan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<String> _download(String url) async {
  final response = await http.get(Uri.parse(url), headers: {
    HttpHeaders.authorizationHeader: 'Basic bWFub3M6TWFuMThWcGxhbg=='
  });

  return utf8.decode(response.bodyBytes);
}

Future<VPlan> _downloadVPlanURL(String typ) async {
  return vPlanFromJson(await _download(typ));
}

enum VPlanType { next, current }

Future<VPlan> _downloadVPlan(VPlanType typ) async {
  switch (typ) {
    case VPlanType.current:
      return await _downloadVPlanURL(
          'https://manos-dresden.de/vplan/upload/current/students.json');
    case VPlanType.next:
      return await _downloadVPlanURL(
          'https://manos-dresden.de/vplan/upload/next/students.json');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String commit = "2be908d5914d6ae327ddd41184ce999076f5c236";
  bool loading = true;
  List<Widget> tabViews = const [
    vPlanTable(
        url: 'https://manos-dresden.de/vplan/upload/current/students.json'),
    vPlanTable(url: 'https://manos-dresden.de/vplan/upload/next/students.json'),
    SizedBox()
  ];

  Widget _offsetPopup() => PopupMenuButton<int>(
      itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: const Text(
                "Current",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: const Text(
                "Next",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: const Text(
                "Custom",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ],
      icon: Container(
        height: double.infinity,
        width: double.infinity,
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        decoration: ShapeDecoration(
            color: Theme.of(context).primaryColor,
            shape: const StadiumBorder()),
      ));

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 10.1,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Einstellungen',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This is a snackbar')));
                },
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                tooltip: 'Kalender',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This is a snackbar')));
                },
              ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(10),
              child: TabBar(
                tabs: [
                  Tab(text: "Heute"),
                  Tab(text: "Folgend"),
                  Tab(icon: Icon(Icons.directions_bike)),
                ],
              ),
            ),
          ),
          body: TabBarView(children: tabViews),
          floatingActionButton: Align(
              alignment: Alignment.bottomRight,
              child:
                  SizedBox(height: 80.0, width: 80.0, child: _offsetPopup())),
        ));
  }
}
