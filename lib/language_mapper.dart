class LanguageMapper {
  final String language;

  LanguageMapper(this.language);

  String getTitle(String key) {
    switch (language) {
      case 'cs':
        return _csTitles[key] ?? '';
      case 'en':
        return _enTitles[key] ?? '';
      case 'ru':
        return _ruTitles[key] ?? '';
      default:
        return _enTitles[key] ?? '';
    }
  }

  String getBody(String key) {
    switch (language) {
      case 'cs':
        return _csBodies[key] ?? '';
      case 'en':
        return _enBodies[key] ?? '';
      case 'ru':
        return _ruBodies[key] ?? '';
      default:
        return _enBodies[key] ?? '';
    }
  }

  static const Map<String, String> _csTitles = {
    'welcome': 'Vítejte',
    'learn': 'Učit se',
    'get_started': 'Začít',
    'done': 'Hotovo',
    'skip': 'Přeskočit',
    'username': 'Uživatelské jméno',
    'password': 'Heslo',
    'login': 'Přihlásit se',
    'register': 'Registrovat se',
    'registration': 'Registrace',
    'first_name': 'Jméno',
    'last_name': 'Příjmení',
    'email': 'Email',
    'select_level': 'Vyberte úroveň',
  };

  static const Map<String, String> _enTitles = {
    'welcome': 'Welcome',
    'learn': 'Learn',
    'get_started': 'Get Started',
    'done': 'Done',
    'skip': 'Skip',
    'username': 'Username',
    'password': 'Password',
    'login': 'Log In',
    'register': 'Register',
    'registration': 'Registration',
    'first_name': 'First Name',
    'last_name': 'Last Name',
    'email': 'Email',
    'select_level': 'Select Level',
  };

  static const Map<String, String> _ruTitles = {
    'welcome': 'Добро пожаловать',
    'learn': 'Учиться',
    'get_started': 'Начать',
    'done': 'Готово',
    'skip': 'Пропустить',
    'username': 'Имя пользователя',
    'password': 'Пароль',
    'login': 'Войти',
    'register': 'Зарегистрироваться',
    'registration': 'Регистрация',
    'first_name': 'Имя',
    'last_name': 'Фамилия',
    'email': 'Эл. почта',
    'select_level': 'Выберите уровень',
  };

  static const Map<String, String> _csBodies = {
    'welcome': 'Vítejte v Learn Czech, nejlepší aplikaci pro učení češtiny.',
    'learn': 'Učte se česky s interaktivními lekcemi a kvízy.',
    'get_started':
        'Zaregistrujte se nebo se přihlaste a začněte se učit česky ještě dnes!',
  };

  static const Map<String, String> _enBodies = {
    'welcome': 'Welcome to Learn Czech, the best app to learn Czech language.',
    'learn': 'Learn Czech with interactive lessons and quizzes.',
    'get_started': 'Sign up or log in to start learning Czech today!',
  };

  static const Map<String, String> _ruBodies = {
    'welcome':
        'Добро пожаловать в Learn Czech, лучшее приложение для изучения чешского языка.',
    'learn': 'Учите чешский язык с интерактивными уроками и викторинами.',
    'get_started':
        'Зарегистрируйтесь или войдите, чтобы начать изучать чешский язык уже сегодня!',
  };
}
