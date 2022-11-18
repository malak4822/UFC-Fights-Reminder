import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCard extends StatefulWidget {
  const MyCard({
    super.key,
    @required this.cardId,
    @required this.fighterName,
    @required this.firPhotoUrl,
  });

  @override
  State<MyCard> createState() => _CardState();
  final cardId;
  final fighterName;
  final firPhotoUrl;
}

bool isDialogShown = false;
bool shouldRemind = false;

class _CardState extends State<MyCard> {
  Future getFightInfo() async {
    print("FIGHT INFO");
  }

  void showDialog() {
    setState(() {
      if (isDialogShown) {
        isDialogShown = false;
      } else {
        isDialogShown = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Visibility(
          visible: isDialogShown,
          child: FutureBuilder(
              future: getFightInfo().then((value) => value),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return const AlertDialog(
                  title: Text("Ostrzenie"),
                  actions: [Text("Es")],
                  backgroundColor: Colors.green,
                );
              })),
      GestureDetector(
          onDoubleTap: showDialog,
          child: Card(
              elevation: 5,
              margin: const EdgeInsets.all(5),
              color: const Color.fromRGBO(32, 32, 32, 1),
              child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.network(widget.firPhotoUrl,
                            height: 90, cacheHeight: 90),
                        Expanded(
                            child: Text(
                          style:
                              GoogleFonts.overpass(fontWeight: FontWeight.bold),
                          widget.fighterName.toString(),
                          textAlign: TextAlign.center,
                        )),
                        Image.network(widget.firPhotoUrl,
                            height: 90, cacheHeight: 90),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child:
                                    // Text("karta nr ${widget.cardId.toString()}"),
                                    Switch(
                                  activeColor:
                                      const Color.fromARGB(255, 155, 10, 0),
                                  onChanged: (isOn) {
                                    setState(() {
                                      shouldRemind = isOn;
                                    });
                                  },
                                  value: shouldRemind,
                                )))
                      ]))))
    ]);
  }
}
