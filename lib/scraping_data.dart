// import 'package:http/http.dart' as http;
// import 'package:html/dom.dart' as dom;


// class scrapingFunctions {
//    scrapingFunctions({this.foundCards, this.fightersNames,})

//   late int foundCards;
//   late fightersNames ;

//   Future getWebsiteBasics() async {
//     final response = await http.get(Uri.parse(
//         "https://www.ufc.com/event/ufc-fight-night-february-04-2023"));
//     dom.Document html = dom.Document.html(response.body);

//     final entireCard = html
//         .querySelectorAll("div > div.c-listing-fight__content-row")
//         .toList();
//     foundCards = entireCard.length;

//     final fighterNames = entireCard
//         .map((e) => e
//             .getElementsByClassName('c-listing-fight__corner-name')
//             .map(
//                 (e) => e.text.trim().replaceAll('  ', '').replaceAll('\n', ' '))
//             .toList())
//         .toList();
//     fightersNames = fighterNames;

//     final imgs = entireCard
//         .map((e) => e
//             .querySelectorAll('img')
//             .map((a) => a.attributes['src']!
//                 .replaceAll(
//                     '/themes/custom/ufc/assets/img/standing-stance-left-silhouette.png',
//                     'https://www.ufc.com/themes/custom/ufc/assets/img/standing-stance-left-silhouette.png')
//                 .replaceAll(
//                     '/themes/custom/ufc/assets/img/standing-stance-right-silhouette.png',
//                     'https://www.ufc.com/themes/custom/ufc/assets/img/standing-stance-right-silhouette.png')
//                 .replaceAll('/n', ' '))
//             .toList())
//         .toList();
//     imageUrls = imgs;
//   }
// }
