

class BackgroundService {
  BackgroundService(
    this.foundCards,
    this.mainNumber,
    this.preNumber,
    this.timeList,
    this.fightersNames,
    this.imageUrls,
  );

  int foundCards;
  int mainNumber;
  int preNumber;
  List<String> timeList;
  List<List<String>> fightersNames = [];
  List<List<String>> imageUrls = [];
}
