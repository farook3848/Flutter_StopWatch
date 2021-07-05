import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration duration = Duration();
  Timer? timer;
  String? minutes;
  String? seconds;
  String? hours;
  List<String> datatime = [];

  Widget buildtime() {
    String twodig(int n) => n.toString().padLeft(2, '0');
    minutes = twodig(duration.inMinutes.remainder(60));
    seconds = twodig(duration.inSeconds.remainder(60));
    hours = twodig(duration.inHours);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        timeCard(time: hours, header: "HOURS"),
        SizedBox(
          width: 8,
        ),
        timeCard(time: minutes, header: "MINUTES"),
        SizedBox(
          width: 8,
        ),
        timeCard(time: seconds, header: "SECONDS"),
      ],
    );
  }

  Widget timeCard({required String? time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Text(
            time!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 72,
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(header,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget buildbutt() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning || duration.inSeconds != 00
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                  ),
                  onPressed: () {
                    if (isRunning) {
                      setState(() {
                        timer?.cancel();
                      });
                    } else {
                      starttimer();
                    }
                  },
                  child: isRunning
                      ? Text(
                          "Pause",
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          "Resume",
                          style: TextStyle(color: Colors.black),
                        )),
              SizedBox(
                width: 12,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      datatime.insert(0, "$hours:$minutes:$seconds");
                    });
                  },
                  child: Text(
                    "Lap",
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(
                width: 12,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      datatime.clear();
                      timer?.cancel();
                      duration = Duration();
                    });
                  },
                  child: Text(
                    "Reset",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow,
            ),
            onPressed: () {
              starttimer();
            },
            child: Text(
              "Start",
              style: TextStyle(color: Colors.black),
            ));
  }

  void addtime() {
    final addsec = 1;

    setState(() {
      final seconds = duration.inSeconds + addsec;
      duration = Duration(seconds: seconds);
    });
  }

  void starttimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      addtime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("StopWatch", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellow,
      ),
      body: Center(
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildtime(),
              SizedBox(
                height: 80,
              ),
              buildbutt(),
              SizedBox(
                height: 80,
              ),
              Container(
                height: 200,
                child: datatime.isEmpty
                    ? Center(
                        child: Text("No Laps",
                            style: TextStyle(color: Colors.white)),
                      )
                    : ListView.builder(
                        itemCount: datatime.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '${datatime[index]}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Divider(
                                    color: Colors.yellow,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
