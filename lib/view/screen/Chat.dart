
class Chat {
  String _agentid;
  String _agentmessage;
  String _userid;
  String _usermessage;


  Chat(this._agentid, this._agentmessage, this._userid, this._usermessage);

  Chat.map(dynamic obj) {
    this._agentid = obj['agentid'];
    this._agentmessage = obj['agentmessage'];
    this._userid = obj['userid'];
    this._usermessage = obj['usermessage'];
  }

  String get agentid => _agentid;
  String get agentmessage => _agentmessage;
  String get userid => _userid;
  String get usermessage => _usermessage;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['agentid'] = _agentid;
    map['agentmessage'] = _agentmessage;
    map['userid'] = _userid;
    map['usermessage'] = _usermessage;
    return map;
  }

  Chat.fromMap(Map<String, dynamic> map) {
    this._agentid = map['agentid'];
    this._agentmessage = map['agentmessage'];
    this._userid = map['userid'];
    this._usermessage = map['usermessage'];
  }
}