import 'package:flutter/material.dart';
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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> shouldRemind;

  @override
  void initState() {
    super.initState();
    shouldRemind = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('boolSwitcherKey') ?? false;
    });
  }

  Future<void> changeAndSafeBool() async {
    final SharedPreferences prefs = await _prefs;
    final bool counter = (prefs.getBool('boolSwitcherKey') ?? false);

    setState(() {
      if (prefs.getBool('boolSwitcherKey') == false) {
        shouldRemind = prefs
            .setBool('boolSwitcherKey', counter)
            .then((bool success) => true);
      } else {
        shouldRemind = prefs
            .setBool('boolSwitcherKey', counter)
            .then((bool success) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => changeAndSafeBool(),
        child: Card(
          elevation: 10,
          margin: const EdgeInsets.all(2),
          color:
              // shouldRemind
              //     ? const Color.fromARGB(255, 108, 0, 0):
              const Color.fromRGBO(32, 32, 32, 1),
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
                          onPressed: () => changeAndSafeBool(),
                          icon: const Icon(Icons.alarm),
                          label: const Text("dodaj")),
                      FutureBuilder(
                          future: shouldRemind,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
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
