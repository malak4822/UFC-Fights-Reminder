import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loneguide/card.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

void main() {
  runApp(const MyApp());
}

// final cardNumber = List<int>.generate(3, (int index) => index);

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
    super.initState();
    getWebsiteData();
  }
  // var cardId = List<int>.generate(4, (index) => index);

  List<String> fightersNames = [];

  Future getWebsiteData() async {
    final url = Uri.parse("https://www.ufc.com/events#events-list-upcoming");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final fightAvatars = html
        .getElementsByClassName("image-style-event-results-athlete-headshot")
        .take(6)
        .map((element) => element.attributes['src'])
        .toList();

    // .querySelectorAll("div.field > article.media < img.")
    // .take(4)
    // .map((element) => element.innerHtml.toString());

    print("count ${fightAvatars.length}");

    for (final imgs in fightAvatars) {
      debugPrint(imgs.toString());
    }

    final fightNames = html
        .querySelectorAll("h3.c-card-event--result__headline > a")
        .map((element) => element.innerHtml.toString())
        .toList();
    fightersNames = fightNames;
  }

  int fir = 1;
  int sec = 2;
  int third = 3;

  @override
  Widget build(BuildContext context) {
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
                  style: GoogleFonts.actor(
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
          // Column(children: cardsNumVal),
          Column(
            children: [
              FutureBuilder(
                future: getWebsiteData().then((value) => value),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        strokeWidth: 12,
                      );
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          children: [
                            MyCard(
                                cardId: fir, fighterName: fightersNames[fir]),
                            MyCard(
                                cardId: sec, fighterName: fightersNames[sec]),
                            MyCard(
                                cardId: third,
                                fighterName: fightersNames[third]),
                          ],
                        );
                      }
                  }
                },
              ),
            ],
          )
        ]));
  }
}
