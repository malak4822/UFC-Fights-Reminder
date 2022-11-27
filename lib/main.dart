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

  List<String> fightersNames = [];
  List<String> avatarUrl = [];

  Future getWebsiteBasics() async {
    debugPrint("FUNKCJE WYKONANO");
    final response = await http
        .get(Uri.parse("https://www.ufc.com/events#events-list-upcoming"));
    dom.Document html = dom.Document.html(response.body);

    final response1 = await http.get(Uri.parse(
        "https://www.ufc.com/event/ufc-fight-night-december-03-2022"));
    dom.Document html1 = dom.Document.html(response1.body);

// TRZEBA DODAWAĆ PO 2 BO ZBIERA PO JEDNYM ZDJĘCIU
    final fightAvatar = html
        .getElementsByClassName("image-style-event-results-athlete-headshot")
        .take(12)
        .map((element) => element.attributes['src'].toString())
        .toList();

    String doublingAvatars = "";
    int i = 0;
    while (i < 12) {
      doublingAvatars = "${fightAvatar[i]} ${fightAvatar[i + 1]}";
      avatarUrl.add(doublingAvatars);
      i += 2;
    }
// TRZEBA BRAĆ PO 4 BO ZBIERA PO IMIENIU A POTEM NAZWISKU
    final fighterName = html1
        .querySelectorAll("div.c-listing-fight__corner-name > span")
        .take(24)
        .map((e) => e.innerHtml)
        .toList();

    int a = 0;
    String names = "";
    while (a < 24) {
      names = "${fighterName[a + 1]} VS ${fighterName[a + 3]}";
      fightersNames.add(names);
      a = a + 4;
    }
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
                        strokeWidth: 3,
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
                              fighterName: fightersNames[index],
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
