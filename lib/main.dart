import 'package:flutter/material.dart';
import 'package:loneguide/card.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:shared_preferences/shared_preferences.dart';

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

List<int> indexRemindList = [];

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> fightersNames = [];
  List<List<String>> imageUrls = [];

  @override
  void initState() {
    savingData();
    super.initState();
  }

  void savingData() async {
    List<String> stringIndexList =
        indexRemindList.map((e) => e.toString()).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('remindList', stringIndexList);
  }

  Future getWebsiteBasics() async {
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
                    return const SizedBox();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else {
                      return Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                savingData();
                              },
                              //STWORZYĆ PREFERENCESDATA
                              child: const Text("essa")),
                          Column(
                            children: List.generate(
                                4,
                                (index) => MyCard(
                                      cardId: index,
                                      shouldRemindList: indexRemindList,
                                      fighterNames: fightersNames[index],
                                      fightersUrl: imageUrls[index],
                                    )),
                          )
                        ],
                      );
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                }))));
  }
}
