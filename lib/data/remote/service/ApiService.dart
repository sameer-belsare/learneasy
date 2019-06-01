import 'package:learneasy/data/remote/ApiInterface.dart';
import 'package:learneasy/model/Chats.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiService implements ApiInterface {
  final _baseUrl = 'https://swapi.co/api';
  http.Client _client = http.Client();

  static final ApiService _internal = ApiService.internal();
  factory ApiService() => _internal;
  ApiService.internal();

  Future<List<Chats>> getChats() async {
    var chatResponse = await _client.get('$_baseUrl/films');

    if (chatResponse.statusCode == 200) {
      var data = json.decode(chatResponse.body);
      List<dynamic> chatList = data['results'];
      List<Chats> chats = chatList.map((c) => Chats.fromMap(c)).toList();
      return chats;
    } else {
      throw Exception('Chats not availabe this time.');
    }
  }
}
