import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gas_leakage/screen/login.dart';
import 'package:gas_leakage/services/auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<readings> chartData;
  late TooltipBehavior tooltipBehavior;
  late ChartSeriesController _chartSeriesController;

  String reading = "no reading";
  DateTime date = DateTime.now();

  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance
      .ref("UsersData/FEDJ225S8FfqZDTHntX3tMWQo7Y2/readings/");

  //Listening to stream
  @override
  void initState() {
    chartData = getChartData();
    tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x,point.y ');
    super.initState();
    _activeListner();
  }

  void _activeListner() {
    Stream<DatabaseEvent> stream = ref.onChildAdded;
    stream.listen((DatabaseEvent event) {
      dynamic value = {};
      print('Event Type: ${event.type}'); // DatabaseEventType.value;
      value = event.snapshot.value;
      if (value != null) {
        setState(() {
          if (value["timestamp"] != null) {
            date = DateTime.fromMillisecondsSinceEpoch(
                int.parse(value["timestamp"].toString()) * 1000);
          }
          reading = value["temperature"].toString();
          chartData.add(readings(time: date, leakage: double.parse(reading)));
          if (chartData.length == 10) {
            chartData.removeAt(0);
          }
        });
        // chartData.add(readings(time: date, leakage: double.parse(reading)));
        // if (chartData.length == 10) {
        //   chartData.removeAt(0);
        // }
        // _chartSeriesController.updateDataSource(
        //   addedDataIndexes: <int>[chartData.length - 1],
        //   removedDataIndexes: <int>[0],
        // );
      } // DataSnapshot
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              dynamic result = await SignOut();
              //   if (result == null) {
              //     print("logout not succesful");
              //   } else {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                // }
            },
            icon: Icon(Icons.person,color: Colors.pink,),
            label: Text("SignOut"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SfCartesianChart(
                tooltipBehavior: tooltipBehavior,
                title: ChartTitle(text: "Gas readings"),
                primaryXAxis: DateTimeAxis(
                  intervalType: DateTimeIntervalType.seconds,
                  interval: 2.0,
                ),
                series: <ChartSeries<readings, DateTime>>[
                  LineSeries<readings, DateTime>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (readings read, _) => read.time,
                    yValueMapper: (readings read, _) => read.leakage,
                    enableTooltip: true,
                    name: "readings",
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

List<readings> getChartData() {
  List<readings> chartdata = [
    readings(time: DateTime(2022, 4, 12, 6, 30, 55, 10), leakage: 72.0),
    readings(time: DateTime(2022, 4, 12, 6, 30, 57, 20), leakage: 73.0),
    readings(time: DateTime(2022, 4, 12, 6, 30, 59, 30), leakage: 74.0),
    readings(time: DateTime(2022, 4, 12, 6, 31, 01, 40), leakage: 71.0),
    readings(time: DateTime(2022, 4, 12, 6, 31, 03, 50), leakage: 79.0),
    readings(time: DateTime(2022, 4, 12, 6, 31, 05, 60), leakage: 70.0),
    readings(time: DateTime(2022, 4, 12, 6, 31, 07, 70), leakage: 100.0)
  ];
  return chartdata;
}

class readings {
  readings({required this.time, required this.leakage});
  final DateTime time;
  final double leakage;
}
