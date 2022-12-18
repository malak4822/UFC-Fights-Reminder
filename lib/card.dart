import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCard extends StatefulWidget {
  const MyCard({
    super.key,
    required this.cardId,
    required this.fighterNames,
    required this.fightersUrl,
    required this.shouldRemindList,
  });

  @override
  State<MyCard> createState() => _CardState();
  final int cardId;
  final List<String> fighterNames;
  final List<String> fightersUrl;
  final List<int> shouldRemindList;
}

class _CardState extends State<MyCard> {
  bool boolReminder = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
        elevation: 5,
        margin: const EdgeInsets.all(5),
        color: boolReminder
            ? const Color.fromARGB(255, 135, 0, 0)
            : const Color.fromRGBO(32, 32, 32, 1),
        child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: SizedBox(
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    fighterPhoto(0),
                    Expanded(
                        child: Column(children: [
                      Switch(
                          activeColor: const Color.fromARGB(255, 255, 255, 255),
                          onChanged: (isOn) {
                            if (isOn) {
                              widget.shouldRemindList.add(widget.cardId);
                            } else {
                              widget.shouldRemindList.remove(widget.cardId);
                            }
                            print(widget.shouldRemindList);
                            setState(() {
                              boolReminder = isOn;
                            });
                          },
                          value: boolReminder),
                      Text(
                        style:
                            GoogleFonts.overpass(fontWeight: FontWeight.bold),
                        '${widget.fighterNames[0]} \n VS \n ${widget.fighterNames[1]}',
                        textAlign: TextAlign.center,
                      ),
                    ])),
                    fighterPhoto(1)
                  ],
                ))),
      )
    ]);
  }

  Widget fighterPhoto(int intFighter) => Image.network(
        widget.fightersUrl[intFighter],
        alignment: Alignment.topCenter,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width / 3,
        cacheWidth: (80 * MediaQuery.of(context).devicePixelRatio).round(),
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Image.asset('assets/fighterimg.png',
                color: const Color.fromARGB(255, 69, 69, 69),
                cacheWidth: MediaQuery.of(context).size.width ~/ 3);
          }
        },
      );
}

Widget texty(double width) => Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 69, 69, 69),
        borderRadius: BorderRadius.circular(5),
      ),
      height: 20,
      width: width,
    );
