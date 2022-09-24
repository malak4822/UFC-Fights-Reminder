// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 50, 50),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> whatCardIsSelected = [];
  bool switchValue1 = false;

  @override
  Widget build(BuildContext context) {
    Widget card(nrKarty, bool vall) {
      return Card(
        shape: const StadiumBorder(),
        color: const Color.fromARGB(255, 32, 32, 32),
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(children: [
              Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      avatar("https://fwcdn.pl/ppo/47/36/4736/450638.2.jpg"),
                      Text(
                        " V S ",
                        style: GoogleFonts.overpass(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      avatar(
                          "https://img.a.transfermarkt.technology/portrait/big/506948-1596018768.jpg?lm=1")
                    ],
                  )),
              Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Text("karta nr $nrKarty"),
                      Switch(
                        activeColor: const Color.fromARGB(255, 155, 10, 0),
                        onChanged: (isOn) {
                          if (isOn) {
                            whatCardIsSelected.add(nrKarty);
                          }
                          print(whatCardIsSelected);

                          setState(() {
                            switchValue1 = isOn;
                          });
                        },
                        value: vall,
                      )
                    ],
                  ))
            ])),
      );
    }

    List<Widget> cardsNumVal = List.generate(5, (index) => card(index, switchValue1));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/UFC_Logo.svg/1280px-UFC_Logo.svg.png"),
              ),
              Text("REMINDER",
                  style: GoogleFonts.elsieSwashCaps(
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                      color: const Color.fromARGB(255, 189, 13, 0)),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
        body: ListView(children: [
          const SizedBox(height: 20),
          Text(
            "Remind about your fav fights ",
            style:
                GoogleFonts.overpass(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Column(children: cardsNumVal),
        ]));
  }

  Widget avatar(String imgurl) => CircleAvatar(
      backgroundColor: Colors.white,
      radius: 31,
      child: CircleAvatar(radius: 30, backgroundImage: NetworkImage(imgurl)));
}
