class User {
  String _email;
  String _language;
  String _password;
  String _phone;
  String _username;
  String _usertype;

  User(this._email, this._language, this._password, this._phone, this._username,
      this._usertype);

  User.map(dynamic obj) {
    this._email = obj['email'];
    this._email = obj['language'];
    this._password = obj['password'];
    this._phone = obj['phone'];
    this._username = obj['username'];
    this._usertype = obj['usertype'];
  }

  String get email => _email;
  String get language => _language;
  String get password => _password;
  String get phone => _phone;
  String get username => _username;
  String get usertype => _usertype;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_email != null) {
      map['email'] = _email;
    }
    map['language'] = _language;
    map['password'] = _password;
    map['phone'] = _phone;
    map['username'] = _username;
    map['usertype'] = _usertype;
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._email = map['email'];
    this._language = map['language'];
    this._password = map['password'];
    this._phone = map['phone'];
    this._username = map['username'];
    this._usertype = map['usertype'];
  }
}
