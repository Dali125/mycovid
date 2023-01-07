import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:my_africa_my_covid/models/covid_stats.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.deepPurple,
        splashColor: Colors.teal,
      ),
      home: const MyHomePage(title: 'My Africa, My Covid'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {





    var navBars = [ BottomNavigationBarItem(icon: Icon(Icons.home)),
      BottomNavigationBarItem(icon: Icon(Icons.home)),
      BottomNavigationBarItem(icon: Icon(Icons.home)),
      BottomNavigationBarItem(icon: Icon(Icons.home)),];

    Map<String, String> headers = {
      'X-RapidAPI-Key': '84662fd5bemsh1131d91c978521cp154fb2jsn5c49b27e06fd',
      'X-RapidAPI-Host':
          'vaccovid-coronavirus-vaccine-and-treatment-tracker.p.rapidapi.com'
    };

    List<CovidStats> parseStats(String responseBody) {
      final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

      return parsed
          .map<CovidStats>((json) => CovidStats.fromJson(json))
          .toList();
    }

    Future<List<CovidStats>> getStats(http.Client client) async {
      final response = await client.get(
          Uri.parse(
              'https://vaccovid-coronavirus-vaccine-and-treatment-tracker.p.rapidapi.com/api/npm-covid-data/africa'),
          headers: headers);

      return compute(parseStats, response.body);
    }

    setState(() {

    });

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: FutureBuilder<List<CovidStats>>(
          future: getStats(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error, No Network'));
            } else if (snapshot.hasData) {
              return CovidStatsList(
                covidStats: snapshot.data!,
              );
            } else {
              print(covidStatsFromJson.toString());
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
    bottomNavigationBar: BottomNavigationBar(items: navBars),);
  }
}

class CovidStatsList extends StatelessWidget {
  final List<CovidStats> covidStats;

  const CovidStatsList({required this.covidStats});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: covidStats.length,
        itemBuilder: (context, index) {
          return Container(
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepPurpleAccent,
            ),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(10),
            child: Flex(direction: Axis.vertical, children: [
              Expanded(
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      covidStats[index].country,
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          " Located in : ${covidStats[index].continent}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          " Total Population: ${covidStats[index].population}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          " Total Cases(as at ${DateTime.now().year}): ${covidStats[index].totalCases}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          " Active Cases(as at ${DateTime.now().year}): ${covidStats[index].activeCases}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          " Infection Risk:  ${covidStats[index].infectionRisk}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          " Case Fatality Rate:  ${covidStats[index].caseFatalityRate}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          " New Deaths :  ${covidStats[index].newDeaths}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          " Rank :  ${covidStats[index].rank}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                            " Population: ${covidStats[index].activeCases}")),
                    Text(
                        " Total Cases: ${covidStats[index].totalCases.toString()}"),
                  ],
                ),
              )
            ]),
          );

        });
  }

}
