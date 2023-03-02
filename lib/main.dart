import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loneguide/card.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:loneguide/notificationservice.dart';
import 'package:timezone/data/latest.dart' as timezone;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
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

List<int> remindIndexList = [];

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> fightersNames = [];
  List<List<String>> imageUrls = [];
  late int foundCards;
  late int mainNumber;
  late int preNumber;
  late List<String> timeList;

  List<String> timeAndHeadings = [];
  late int cardIndex;

  Future getWebsiteBasics() async {
    final response =
        await http.get(Uri.parse("https://www.ufc.com/event/ufc-285"));
    dom.Document html = dom.Document.html(response.body);

    final entireCard =
        html.querySelectorAll("div > div.c-listing-fight__content-row");
    foundCards = entireCard.length;

    final maine = html.querySelectorAll("#main-card > div > section > ul > li");
    mainNumber = maine.length;

    final pre =
        html.querySelectorAll("#prelims-card > div > section > ul > li");
    preNumber = pre.length;

    final fightDates = html
        .querySelectorAll(
            'div.c-event-fight-card-broadcaster__mobile-wrapper > div.c-event-fight-card-broadcaster__time.tz-change-inner')
        .map((e) => e.text.trim())
        .toList();

    timeList = fightDates;
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
                .replaceAll(
                    '/themes/custom/ufc/assets/img/standing-stance-right-silhouette.png',
                    'https://www.ufc.com/themes/custom/ufc/assets/img/standing-stance-right-silhouette.png')
                .replaceAll('/n', ' '))
            .toList())
        .toList();
    imageUrls = imgs;
  }

  @override
  void initState() {
    timezone.initializeTimeZones();
    super.initState();
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
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (BuildContext context, index) {
                        return loadingCard();
                      },
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Column(children: [
                        const CircularProgressIndicator(),
                        Text(
                          'Internet Connection Error',
                          style: GoogleFonts.overpass(fontSize: 40),
                        )
                      ]));
                    } else {
                      return SingleChildScrollView(
                          child: Column(
                        children: List.generate(foundCards, (index) {
                          cardIndex = index;

                          if (index == 0) {
                            return showTitles("MAIN CARD\n${timeList[0]}");
                          }

                          if (index == mainNumber) {
                            return showTitles("PRELIMS\n${timeList[1]}");
                          }

                          if (index == mainNumber + preNumber) {
                            return showTitles('EARLY PRELIMS\n${timeList[2]}');
                          }

                          return MyCard(
                            cardId: index,
                            fighterNames: fightersNames[index],
                            fightersUrl: imageUrls[index],
                          );
                        }),
                      ));
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                }))));
  }

  Widget showTitles(String txt) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 10),
            width: double.infinity,
            color: const Color.fromARGB(255, 108, 0, 0),
            child: Text(
              txt,
              textAlign: TextAlign.center,
              style: GoogleFonts.akronim(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                  fontSize: 24),
            )),
        MyCard(
          cardId: cardIndex,
          fighterNames: fightersNames[cardIndex],
          fightersUrl: imageUrls[cardIndex],
        )
      ],
    );
  }

  Widget loadingCard() => const Card(
      elevation: 10,
      color: Color.fromRGBO(32, 32, 32, 1),
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 8, right: 8),
        child: SizedBox(height: 140),
      ));
}
