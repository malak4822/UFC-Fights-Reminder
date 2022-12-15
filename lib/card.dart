import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCard extends StatefulWidget {
  const MyCard({
    super.key,
    required this.cardId,
    required this.fighterNames,
    required this.fighterUnoUrl,
    required this.fighterDuoUrl,
  });

  @override
  State<MyCard> createState() => _CardState();
  final int cardId;
  final List<String> fighterNames;
  final String fighterUnoUrl;
  final String fighterDuoUrl;
}

bool shouldRemind = false;

class _CardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
          elevation: 5,
          margin: const EdgeInsets.all(5),
          color: const Color.fromRGBO(32, 32, 32, 1),
          child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
              child: SizedBox(
                  height: 140,
                  child: Row(children: [
                    Image.network(
                      widget.fighterUnoUrl,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const CircularProgressIndicator();
                      },
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      width: 120,
                      cacheWidth: (80 * MediaQuery.of(context).devicePixelRatio)
                          .round(),
                    ),
                    Expanded(
                        child: Column(children: [
                      Switch(
                        activeColor: const Color.fromARGB(255, 155, 10, 0),
                        onChanged: (isOn) {
                          setState(() {
                            shouldRemind = isOn;
                          });
                        },
                        value: shouldRemind,
                      ),
                      Text(
                        style:
                            GoogleFonts.overpass(fontWeight: FontWeight.bold),
                        '${widget.fighterNames[0]} \n VS \n ${widget.fighterNames[1]}',
                        textAlign: TextAlign.center,
                      ),
                    ])),
                    Image.network(
                      widget.fighterDuoUrl,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const CircularProgressIndicator();
                      },
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      width: 120,
                      cacheWidth: (80 * MediaQuery.of(context).devicePixelRatio)
                          .round(),
                    ),
                  ]))))
    ]);
  }
}
