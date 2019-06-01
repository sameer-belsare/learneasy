import 'package:learneasy/model/Chats.dart';

abstract class ApiInterface {
  Future<List<Chats>> getChats();
}
