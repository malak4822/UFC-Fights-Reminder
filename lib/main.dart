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
  @override
  void initState() {
    getWebsiteBasics();

    super.initState();
  }
  // var cardId = List<int>.generate(4, (index) => index);

  List<String> fightersNames = [];
  List<String> avatarUrl = [];

  final url = Uri.parse("https://www.ufc.com/events#events-list-upcoming");

  Future getWebsiteBasics() async {
    print("FUNKCJE WYKONANO");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final response1 = await http.get(Uri.parse(
        "https://www.ufc.com/event/ufc-fight-night-december-03-2022"));
    dom.Document html1 = dom.Document.html(response1.body);

// PODSTAWOWE DANE
    final fightAvatar = html
        .getElementsByClassName("image-style-event-results-athlete-headshot")
        .take(30)
        .map((element) => element.attributes['src'].toString())
        .toList();

    String doublingAvatars = "";
    int i = 0;
    while (i < 30) {
      doublingAvatars = "${fightAvatar[i]} ${fightAvatar[i + 1]}";
      avatarUrl.add(doublingAvatars);
      i += 2;
    }
// getElementsByClassName("c-listing-fight__corner-given-name")
    final fighterName = html1
        .querySelectorAll(
            "div.c-listing-fight__corner-name.c-listing-fight__corner-name--red > span")
        .take(12)
        .map((element) => element.innerHtml)
        .toList();

    int a = 0;
    String doublingNames = "";
    while (a < 12) {
      doublingNames = "${fighterName[a]} ${fighterName[a + 1]}";
      fightersNames.add(doublingNames);
      a += 2;
    }

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
          const SizedBox(height: 20),
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
                        strokeWidth: 3,
                      );
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                            children: List.generate(
                          5,
                          (index) {
                            return MyCard(
                              cardId: index,
                              fighterName: fightersNames[index].split(' ').toString(),
                              photoUrls: avatarUrl[index].split(' '),
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
