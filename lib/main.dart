import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loneguide/card.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

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
          bodyMedium: TextStyle(),
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
  List<String?> fightersNames = [];
  List<String?> redCornerUrls = [];
  List<String?> blueCornerUrls = [];

  Future getWebsiteBasics() async {
    debugPrint("FUNKCJE WYKONANO");
    final response = await http.get(Uri.parse(
        "https://www.ufc.com/event/ufc-fight-night-december-17-2022"));
    dom.Document html = dom.Document.html(response.body);

    final entireCard = html
        .querySelectorAll("c-listing-fight__content-row")
        .take(5)
        .map((element) => element.attributes["src"])
        .toList();

    final redCornerAvatars = html
        .querySelectorAll(
            "div.c-listing-fight__corner-image--red > div.layout.layout--onecol > div > img")
        .take(4)
        .map((element) => element.attributes["src"])
        .toList();

    final blueCornerAvatars = html
        .querySelectorAll(
            "div.c-listing-fight__corner-image--blue > div.layout.layout--onecol > div > img")
        .take(4)
        .map((element) => element.attributes["src"])
        .toList();

    final fighterNames = html
        .getElementsByClassName("c-listing-fight__names-row")
        .take(8)
        .map((e) => e.text.toUpperCase().trim())
        .toList();

    redCornerUrls = redCornerAvatars;
    blueCornerUrls = blueCornerAvatars;
    fightersNames = fighterNames;

    // int i = 0;
    // while (i < 8) {
    //   fightersNames.add(fighterNames[i] + fighterNames[i + 1]);

    //   i += 2;
    // }
    print(fightersNames);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black45,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/UFC_Logo.svg/1280px-UFC_Logo.svg.png"),
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: ListView(children: [
          Column(
            children: [
              FutureBuilder(
                future: getWebsiteBasics(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                      );
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                            children: List.generate(
                          4,
                          (index) {
                            return MyCard(
                              cardId: index,
                              redCornerImg: redCornerUrls[index]!,
                              blueCornerImg: blueCornerUrls[index]!,
                              fighterNames: fightersNames[index]!,
                            );
                          },
                        ));
                      }
                  }
                },
              ),
            ],
          )
        ])));
  }
}
