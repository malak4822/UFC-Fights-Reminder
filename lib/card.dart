import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCard extends StatefulWidget {
  const MyCard({
    super.key,
    required this.cardId,
    required this.redCornerImg,
    required this.blueCornerImg,
    required this.fighterNames,
  });

  @override
  State<MyCard> createState() => _CardState();
  final int cardId;
  final String redCornerImg;
  final String blueCornerImg;
  final String fighterNames;
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.network(widget.redCornerImg, height: 150),
                    Expanded(
                        child: Text(
                      style: GoogleFonts.overpass(fontWeight: FontWeight.bold),
                      widget.fighterNames,
                      textAlign: TextAlign.center,
                    )),
                    Image.network(widget.blueCornerImg, height: 150),
                    Expanded(
                        child: Switch(
                      activeColor: const Color.fromARGB(255, 155, 10, 0),
                      onChanged: (isOn) {
                        setState(() {
                          shouldRemind = isOn;
                        });
                      },
                      value: shouldRemind,
                    ))
                  ])))
    ]);
  }
}
