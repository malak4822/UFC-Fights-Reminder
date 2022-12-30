import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCard extends StatefulWidget {
  const MyCard({
    super.key,
    required this.cardId,
    required this.fighterNames,
    required this.fightersUrl,
  });

  @override
  State<MyCard> createState() => _CardState();
  final int cardId;
  final List<String> fighterNames;
  final List<String> fightersUrl;
}

class _CardState extends State<MyCard> {
  bool shouldRemind = false;

  void changeColors() {
    setState(() {
      if (shouldRemind == false) {
        shouldRemind = true;
      } else {
        shouldRemind = false;
      }
    });
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;

  @override
  void initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('counter') ?? 0;
    });
  }

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt('counter', counter).then((bool success) {
        return counter;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => changeColors(),
        child: Card(
          elevation: 10,
          margin: const EdgeInsets.all(2),
          color: shouldRemind
              ? const Color.fromARGB(255, 108, 0, 0)
              : const Color.fromRGBO(32, 32, 32, 1),
          child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: SizedBox(
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(child: fighterPhoto(0)),
                      // Expanded(
                      //     child: Column(children: [
                      //   const SizedBox(height: 10),
                      //   Icon(Icons.alarm,
                      //       color: Colors.white, size: shouldRemind ? 52 : 38),
                      //   const SizedBox(height: 14),
                      //   Text(
                      //     style: GoogleFonts.overpass(
                      //         fontSize: 16, fontWeight: FontWeight.bold),
                      //     '${widget.fighterNames[0]} \n VS \n ${widget.fighterNames[1]}',
                      //     textAlign: TextAlign.center,
                      //   ),
                      //   const Spacer()
                      // ])),
                      // Expanded(child: fighterPhoto(1)),
                      ElevatedButton.icon(
                          onPressed: () => _incrementCounter(),
                          icon: const Icon(Icons.alarm),
                          label: const Text("dodaj")),
                      FutureBuilder(
                          future: _counter,
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const CircularProgressIndicator();
                              default:
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  print(snapshot);

                                  return Text(
                                    'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.\n\n'
                                    'This should persist across restarts.',
                                  );
                                }
                            }
                          })
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
