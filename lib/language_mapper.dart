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
        return '';
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
        return '';
    }
  }

  String getSkipText() {
    switch (language) {
      case 'cs':
        return 'Přeskočit';
      case 'en':
        return 'Skip';
      case 'ru':
        return 'Пропустить';
      default:
        return 'Skip';
    }
  }

  String getDoneText() {
    switch (language) {
      case 'cs':
        return 'Hotovo';
      case 'en':
        return 'Done';
      case 'ru':
        return 'Готово';
      default:
        return 'Done';
    }
  }

  String getUsernameLabel() {
    switch (language) {
      case 'cs':
        return 'Uživatelské jméno:';
      case 'en':
        return 'Username:';
      case 'ru':
        return 'Имя пользователя:';
      default:
        return 'Username:';
    }
  }

  String getPasswordLabel() {
    switch (language) {
      case 'cs':
        return 'Heslo:';
      case 'en':
        return 'Password:';
      case 'ru':
        return 'Пароль:';
      default:
        return 'Password:';
    }
  }

  String getLoginButtonText() {
    switch (language) {
      case 'cs':
        return 'Přihlásit se';
      case 'en':
        return 'Log In';
      case 'ru':
        return 'Войти';
      default:
        return 'Log In';
    }
  }

  String getRegisterLinkText() {
    switch (language) {
      case 'cs':
        return 'Registrovat se';
      case 'en':
        return 'Register';
      case 'ru':
        return 'Зарегистрироваться';
      default:
        return 'Register';
    }
  }

  static const Map<String, String> _csTitles = {
    'welcome': 'Vítejte',
    'learn': 'Učit se',
    'get_started': 'Začít',
  };

  static const Map<String, String> _enTitles = {
    'welcome': 'Welcome',
    'learn': 'Learn',
    'get_started': 'Get Started',
  };

  static const Map<String, String> _ruTitles = {
    'welcome': 'Добро пожаловать',
    'learn': 'Учиться',
    'get_started': 'Начать',
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
