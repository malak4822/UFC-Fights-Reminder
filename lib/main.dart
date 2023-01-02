import 'package:flutter/material.dart';
import 'package:loneguide/card.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

void main() async {
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
  late int foundCards;

  Future getWebsiteBasics() async {
    final response =
        await http.get(Uri.parse("https://www.ufc.com/event/ufc-283"));
    dom.Document html = dom.Document.html(response.body);

    final entireCard = html
        .querySelectorAll("div > div.c-listing-fight__content-row")
        .toList();
    foundCards = entireCard.length;

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
            .map((a) => a.attributes['src']!
                .replaceAll(
                    '/themes/custom/ufc/assets/img/standing-stance-left-silhouette.png',
                    'https://www.ufc.com/themes/custom/ufc/assets/img/standing-stance-left-silhouette.png')
                .replaceAll('/n', ' '))
            .toList())
        .toList();
    imageUrls = imgs;
  }

  List<int> remindIndexList = [];

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
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            title: loadingCard());
                      },
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Internet Connection Error');
                    } else {
                      return ListView.builder(
                        itemCount: foundCards,
                        prototypeItem: ListTile(
                          title: MyCard(
                            cardId: 0,
                            fighterNames: fightersNames.first,
                            fightersUrl: imageUrls.first,
                          ),
                        ),
                        itemBuilder: (BuildContext context, index) {
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            title: MyCard(
                              cardId: index,
                              fighterNames: fightersNames[index],
                              fightersUrl: imageUrls[index],
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                }))));
  }

  Widget loadingCard() => const Card(
        elevation: 10,
        color: Color.fromRGBO(32, 32, 32, 1),
        child:
            Padding(padding: EdgeInsets.only(), child: SizedBox(height: 180)),
      );
}
