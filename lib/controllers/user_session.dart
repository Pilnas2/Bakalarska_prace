class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  String loggedInUsername = '';
  String loggedInPassword = '';
}

final userSession = UserSession();
