import 'package:flutter/material.dart';

class MyCard extends StatefulWidget {
  const MyCard({super.key, @required this.cardId, @required this.fighterName});

  @override
  State<MyCard> createState() => _CardState();
  final cardId ;
  final fighterName;
}

bool shouldRemind = false;

class _CardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: const Color.fromARGB(255, 32, 32, 32),
      child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(children: [
                // Expanded(
                //     flex: 2,
                //     child: Row(
                //       children: [
                //         avatar("https://fwcdn.pl/ppo/47/36/4736/450638.2.jpg"),
                //         Text(
                //           " V S ",
                //           style: GoogleFonts.overpass(
                //               fontSize: 25, fontWeight: FontWeight.bold),
                //         ),
                //         avatar(
                //             "https://img.a.transfermarkt.technology/portrait/big/506948-1596018768.jpg?lm=1")
                //       ],
                //     )),
                Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Text("karta nr ${widget.cardId.toString()}"),
                        Switch(
                          activeColor: const Color.fromARGB(255, 155, 10, 0),
                          onChanged: (isOn) {
                            setState(() {
                              shouldRemind = isOn;
                            });
                          },
                          value: shouldRemind,
                        )
                      ],
                    ))
              ])
            ],
          )),
    );
  }

  Widget avatar(String imgurl) => CircleAvatar(
      backgroundColor: Colors.white,
      radius: 31,
      child: CircleAvatar(radius: 30, backgroundImage: NetworkImage(imgurl)));
}
