// database table and column names
final String tableChats = 'Chats';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDirector = 'director';
final String columnProducer = 'producer';
final String columnReleaseDate = 'releasedate';
final String columnOpeningCrawl = 'openingcrawl';

// data model class
class ChatTable {
  int id;
  String title;
  String director;
  String producer;
  String releaseDate;
  String openingCrawl;

  ChatTable();

  // convenience constructor to create a Word object
  ChatTable.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    director = map[columnDirector];
    producer = map[columnProducer];
    releaseDate = map[columnReleaseDate];
    openingCrawl = map[columnOpeningCrawl];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDirector: director,
      columnProducer: producer,
      columnReleaseDate: releaseDate,
      columnOpeningCrawl: openingCrawl
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
