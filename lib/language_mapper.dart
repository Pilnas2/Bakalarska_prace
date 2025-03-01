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
    'select_level': 'Vyberte jazykovou úroveň',
    'please_enter_first_name': 'Prosím zadejte jméno',
    'please_enter_last_name': 'Prosím zadejte příjmení',
    'please_enter_username': 'Prosím zadejte uživatelské jméno',
    'please_enter_email': 'Prosím zadejte email',
    'please_enter_password': 'Prosím zadejte heslo',
    'no_user_found': 'Neexustuje žádný uživatel s tímto uživatelským jménem',
    'incorrect_password': 'Nesprávné heslo',
    'error_occurred': 'Došlo k chybě',
    'invalid_email': 'Neplatný email',
    'passwor_too_short': 'Heslo je příliš krátké',
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
    'select_level': 'Select Language Level',
    'please_enter_first_name': 'Please enter first name',
    'please_enter_last_name': 'Please enter last name',
    'please_enter_username': 'Please enter username',
    'please_enter_email': 'Please enter email',
    'please_enter_password': 'Please enter password',
    'no_user_found': 'No user found with this username',
    'incorrect_password': 'Incorrect password',
    'error_occurred': 'An error occurred',
    'invalid_email': 'Invalid email',
    'passwor_too_short': 'Password is too short',
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
    'please_enter_first_name': 'Пожалуйста, введите имя',
    'please_enter_last_name': 'Пожалуйста, введите фамилию',
    'please_enter_username': 'Пожалуйста, введите Пожал',
    'please_enter_email': 'Пожалуйста, введите адрес электронной почты',
    'please_enter_password': 'Пожалуйста, введите пароль',
    'no_user_found': 'Пользователь с таким именем не найден',
    'incorrect_password': 'Неверный пароль',
    'error_occurred': 'Произошла ошибка',
    'invalid_email': 'Неверный адрес электронной почты',
    'passwor_too_short': 'Пароль сли',
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
