import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loneguide/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCard extends StatefulWidget {
  const MyCard({
    super.key,
    required this.fighterNames,
    required this.fightersUrl,
    required this.cardId,
  });

  @override
  State<MyCard> createState() => _CardState();
  final int cardId;
  final List<String> fightersUrl;
  final List<String> fighterNames;
}

class _CardState extends State<MyCard> {
  bool shouldRemind = false;

  @override
  void initState() {
    loadBool();
    super.initState();
  }

  void loadBool() async {
    SharedPreferences sharedBool = await SharedPreferences.getInstance();
    if (sharedBool.getBool('bool_num_${widget.cardId}') == true) {
      setState(() {
        shouldRemind = true;
      });
    }
  }

  void saveBool() async {
    SharedPreferences sharedBool = await SharedPreferences.getInstance();
    sharedBool.setBool('bool_num_${widget.cardId}', shouldRemind);
  }

  void removeBool() async {
    SharedPreferences sharedBool = await SharedPreferences.getInstance();
    sharedBool.remove('bool_num_${widget.cardId}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          setState(() {
            if (shouldRemind == false) {
              shouldRemind = true;
              saveBool();
            } else {
              shouldRemind = false;
              removeBool();
            }
          });
          SharedPreferences sharedBool = await SharedPreferences.getInstance();
        },
        child: Card(
          elevation: 10,
          margin: const EdgeInsets.all(2),
          color: shouldRemind
              ? const Color.fromARGB(255, 108, 0, 0)
              : const Color.fromRGBO(32, 32, 32, 1),
          child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: SizedBox(
                  height: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: fighterPhoto(0)),
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                            Icon(Icons.alarm,
                                color: Colors.white,
                                size: shouldRemind ? 52 : 38),
                            Text(
                              style: GoogleFonts.overpass(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              '${widget.fighterNames[0]} \n VS \n ${widget.fighterNames[1]}',
                              textAlign: TextAlign.center,
                            ),
                          ])),
                      Expanded(child: fighterPhoto(1)),
                    ],
                  ))),
        ));
  }

  Widget fighterPhoto(int intFighter) => Image.network(
        widget.fightersUrl[intFighter],
        alignment: Alignment.topCenter,
        fit: BoxFit.cover,
        cacheWidth: (80 * MediaQuery.of(context).devicePixelRatio).round(),
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Image.asset(
              'assets/fighterImg.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              color: const Color.fromARGB(255, 69, 69, 69),
              cacheWidth:
                  (60 * MediaQuery.of(context).devicePixelRatio).round(),
            );
          }
        },
      );
}
