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
    super.initState();
  }
  // var cardId = List<int>.generate(4, (index) => index);

  List<String> fightersNames = [];
  List<String> avatarUrl = [];

  Future getWebsiteData() async {
    final url = Uri.parse("https://www.ufc.com/events#events-list-upcoming");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
//DATY
    final date = html
        .querySelectorAll("tz-change-data > a")
        .take(3)
        .map((element) => element.innerHtml);
// ZDJĘCIA
    final fightAvatar = html
        .getElementsByClassName("image-style-event-results-athlete-headshot")
        .take(8)
        .map((element) => element.attributes['src'].toString())
        .toList();

    avatarUrl = fightAvatar;
// ZAWODNICY
    final fightNames = html
        .querySelectorAll("h3.c-card-event--result__headline > a)")
        .take(8)
        .map((element) => element.innerHtml)
        .toList();
    fightersNames = fightNames;
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
                future: getWebsiteData().then((value) => value),
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
                          3,
                          (index) {
                            return MyCard(
                              cardId: index,
                              fighterName: fightersNames[index].toString(),
                              firPhotoUrl: avatarUrl[index].toString(),
                              secPhotoUrl: avatarUrl[index].toString(),
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
