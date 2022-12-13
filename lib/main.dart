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
  List<List<String>> fightersNames = [];
  List<List<String>> imageUrls = [];

  Future getWebsiteBasics() async {
    debugPrint("FUNKCJE WYKONANO");
    final response = await http.get(Uri.parse(
        "https://www.ufc.com/event/ufc-fight-night-december-17-2022"));
    dom.Document html = dom.Document.html(response.body);

    final entireCard = html
        .querySelectorAll("div > div.c-listing-fight__content-row")
        .take(10)
        .toList();

    final fighterNames = entireCard
        .map((e) => e
            .getElementsByClassName('c-listing-fight__corner-name')
            .map(
                (e) => e.text.trim().replaceAll('  ', '').replaceAll('\n', ' '))
            .toList())
        .toList();
    fightersNames = fighterNames;

    final imgs = entireCard
        .map((e) => e
            .querySelectorAll('img')
            .map((a) => a.attributes['src']!.replaceAll(
                '/themes/custom/ufc/assets/img/standing-stance-left-silhouette.png',
                'https://www.ufc.com/themes/custom/ufc/assets/img/standing-stance-left-silhouette.png'))
            .toList())
        .toList();
    imageUrls = imgs;

    log(fighterNames.toString());
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
                          10,
                          (index) {
                            return MyCard(
                              cardId: index,
                              urlString: imageUrls[index],
                              fighterNames: fightersNames[index],
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
