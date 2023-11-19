import 'dart:developer';

class Validator {
  static String? validate(String ruleString, String value) {
    List <String> rules = ruleString.split('|');

    for (String rule in rules) {
      List <String> ruleRes = rule.split(':');

      switch (ruleRes[0]) {
        case 'required':
          if (value.isEmpty) {
            return 'Пустое поле';
          }

          break;
        case 'password':
          String res = value.isValidPassword();
          if (value.isEmpty || res == '') {
            break;
          }

          return res;
        case 'username':
          if (value.isEmpty || value.isValidUsername()) {
            break;
          }

          return 'Только латиница и -._\'+';
        case 'email':
          if (value.isEmpty || value.isValidEmail()) {
            break;
          }

          return 'Неверный формат почты';
        case 'numeric':
          if (value.isEmpty || value.isNumeric()) {
            break;
          }
          
          return 'Допустимы только цифры';
        case 'min':
          if (ruleRes[1].isEmpty || !ruleRes[1].isNumeric()) {
            log('Invalid format');
            break;
          }

          final int min = int.parse(ruleRes[1]);

          if (value.isNotEmpty && value.length < min) {
            return 'Минимальная длина $min символов';
          }

          break;
        case 'max':
          if (ruleRes[1].isEmpty || !ruleRes[1].isNumeric()) {
            log('Invalid format');
            break;
          }

          final int max = int.parse(ruleRes[1]);

          if (value.isNotEmpty && value.length > max) {
            return 'Максимальная длина $max символов';
          }

          break;
        default:
          log('Invalid rule');
      }
    }

    return null;
  }
}

extension RegString on String {
  bool isNumeric() {
    return RegExp(r'\d').hasMatch(this);
  }

  bool isAlphanumeric() {
    return RegExp(r'\w').hasMatch(this);
  }

  bool isValidEmail() {
    return RegExp(r"^[\w-._'+]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(trim());
  }

  bool notHasSpaces() {
    return RegExp(r'^\S*$').hasMatch(this);
  }

  String isValidPassword() {
    // return RegExp(r"^[a-z][A-Z][!#$%&'()*+,-./:;<=>?@\[\]^_`{|}~]$").hasMatch(this);
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(this);
    bool hasDigits = RegExp(r'[0-9]').hasMatch(this);
    bool hasLowercase = RegExp(r'[a-z]').hasMatch(this);
    bool hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);

    if (!hasUppercase) return 'Пароль должен содержать символ(-ы) в верхнем регистре';

    if (!hasDigits) return 'Пароль должен содержать цифру(-ы)';

    if (!hasLowercase) return 'Пароль должен содержать символ(-ы) в нижнем регистре';

    if (!hasSpecialCharacters) return 'Пароль должен содержать символ(-ы) !@#\$%^&*(),.?":{}|<>';

    if (!notHasSpaces()) return 'Пароль содержит пробелы';

    return '';
  }

  bool isValidUsername() {
    return RegExp(r"^\w*[-._'+]*$").hasMatch(trim()) & notHasSpaces();
  }
}