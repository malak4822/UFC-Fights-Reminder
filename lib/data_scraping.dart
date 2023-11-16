import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

class DataScrapper {
  void downloadWebsiteContent() async {
    final response = await http.get(Uri.parse(
        'https://api.sportsdata.io/v3/mma/scores/json/Schedule/ufc/2023?key=3f07950968b24e0b87299cf4d381c324')); // Replace with the desired website URL

    if (response.statusCode == 200) {
      final document = htmlParser.parse(response.body);

      debugPrint(
          'Title of the website: ${document.querySelector('title')?.text}');
      debugPrint("Body: ${document.outerHtml}");
    } else {
      throw Exception('Failed to load website content');
    }
  }
}
