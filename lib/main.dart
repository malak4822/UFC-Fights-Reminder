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

  @override
  void initState() {
    getWebsiteBasics();
    super.initState();
  }

  Future getWebsiteBasics() async {
    debugPrint("FUNKCJE WYKONANO");
    final response = await http.get(Uri.parse(
        "https://www.ufc.com/event/ufc-fight-night-december-17-2022"));
    dom.Document html = dom.Document.html(response.body);

    final entireCard = html
        .querySelectorAll("div > div.c-listing-fight__content-row")
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
            child: FutureBuilder(
                future: getWebsiteBasics(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView(children: [
                      loadingCard(),
                      loadingCard(),
                      loadingCard(),
                      loadingCard(),
                      loadingCard(),
                    ]);
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else {
                      return ListView(
                        children: List.generate(
                            14,
                            (index) => MyCard(
                                  cardId: index,
                                  fighterNames: fightersNames[index],
                                  urlString: imageUrls[index],
                                )),
                      );
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                }))));
  }
}

Widget loadingCard() => Padding(
    padding: const EdgeInsets.all(5),
    child: Container(
      height: 140,
      color: const Color.fromRGBO(32, 32, 32, 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/fighterimg.png',
              color: const Color.fromARGB(255, 69, 69, 69), cacheWidth: 140),
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            texty(100),
            texty(40),
            texty(100),
          ]),
          Image.asset('assets/fighterimg.png',
              color: const Color.fromARGB(255, 69, 69, 69), cacheWidth: 140),
        ],
      ),
    ));

Widget texty(double width) => Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 69, 69, 69),
        borderRadius: BorderRadius.circular(5),
      ),
      height: 20,
      width: width,
    );
