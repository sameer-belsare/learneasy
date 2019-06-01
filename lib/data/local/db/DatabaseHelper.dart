import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:learneasy/data/local/db/table/ChatTable.dart';
import 'package:learneasy/model/Chats.dart';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableChats (
                $columnId INTEGER PRIMARY KEY,
                $columnTitle TEXT NOT NULL,
                $columnDirector TEXT NOT NULL,
                 $columnProducer TEXT NOT NULL,
                  $columnReleaseDate TEXT NOT NULL,
                   $columnOpeningCrawl TEXT NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(ChatTable chats) async {
    Database db = await database;
    int id = await db.insert(tableChats, chats.toMap());
    return id;
  }

  Future<ChatTable> queryChats(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableChats,
        columns: [columnId, columnTitle, columnDirector,columnProducer,columnReleaseDate,columnOpeningCrawl],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ChatTable.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Chats>> queryChatsAll() async {
    Database db = await database;
    List<Map> maps = await db.query(tableChats,
        columns: [columnId, columnTitle, columnDirector,columnProducer,columnReleaseDate,columnOpeningCrawl]);
    List<Chats> chats = new List();
    for(int i=0; i < maps.length; i++){
      Chats chat = new Chats();
      ChatTable chatTable = ChatTable.fromMap(maps.elementAt(i));
      chat.title = chatTable.title;
      chat.director = chatTable.director;
      //chat.releaseDate = chatTable.releaseDate;
      chat.openingCrawl = chatTable.openingCrawl;
      chats.add(chat);
    }
    var length = chats.length;
    print('chats.count ===>>> $length');
    return chats;
  }

  saveChats(List<Chats> chatList) async {
    for(int i=0 ; i<chatList.length;i++){
      ChatTable chat = ChatTable();
      chat.title = chatList.elementAt(i).title;
      chat.director = chatList.elementAt(i).director;
      chat.producer = chatList.elementAt(i).producer;
      chat.releaseDate = chatList.elementAt(i).releaseDate.toString();
      chat.openingCrawl = chatList.elementAt(i).openingCrawl;
      int  id = await insert(chat);
      print('save id ===>>> $id');
    }
  }

  Future<List<Chats>> getChatsFromDB() async{
    return await queryChatsAll();
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}
