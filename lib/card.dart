import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCard extends StatefulWidget {
  const MyCard({
    super.key,
    required this.cardId,
    required this.urlString,
    required this.fighterNames,
  });

  @override
  State<MyCard> createState() => _CardState();
  final int cardId;
  final List<String> urlString;
  final List<String> fighterNames;
}

bool isDialogShown = false;
bool shouldRemind = false;

class _CardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Visibility(
          visible: isDialogShown,
          child: FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
            return const AlertDialog(
              title: Text("Ostrzenie"),
              actions: [Text("Es")],
              backgroundColor: Colors.green,
            );
          })),
      Card(
          elevation: 5,
          margin: const EdgeInsets.all(5),
          color: const Color.fromRGBO(32, 32, 32, 1),
          child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: SizedBox(
                  height: 120,
                  child: Row(children: [
                    Image.network(
                      widget.urlString[0],
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      width: 120,
                      cacheWidth: (60 * MediaQuery.of(context).devicePixelRatio)
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
                        '${widget.fighterNames[0]} VS ${widget.fighterNames[1]}',
                        textAlign: TextAlign.center,
                      ),
                    ])),
                    Image.network(
                      widget.urlString[1],
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
