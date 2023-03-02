import 'dart:developer';

class Validator {
  static String? validate(String ruleString, String value) {
    List <String> rules = ruleString.split('|');

    for (String rule in rules) {
      List <String> ruleRes = rule.split(':');

      switch (ruleRes[0]) {
        case 'password':
          if (value.isValidPassword()) {
            break;
          }

          return 'Неверный формат пароля';
        case 'username':
          if (value.isValidUsername()) {
            break;
          }

          return 'Только латинница и -._\'+';
        case 'email':
          if (value.isValidEmail()) {
            break;
          }

          return 'Неверный формат почты';
        case 'required':
          if (value.isEmpty) {
            return 'Пустое поле';
          }

          break;
        case 'numeric':
          if (value.isNumeric()) {
            break;
          }
          
          return 'Допустимы только цифры';
        case 'min':
          if (ruleRes[1].isEmpty || !ruleRes[1].isNumeric()) {
            log('Invalid format');
            break;
          }

          final int min = int.parse(ruleRes[1]);

          if (value.length < min) {
            return 'Минимальная длина $min символов';
          }

          break;
        case 'max':
          if (ruleRes[1].isEmpty || !ruleRes[1].isNumeric()) {
            log('Invalid format');
            break;
          }

          final int max = int.parse(ruleRes[1]);

          if (value.length > max) {
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
    return RegExp(r"^[\w-._'+]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(this.trim());
  }

  bool isValidPassword() {
    // return RegExp(r"^[a-z][A-Z][!#$%&'()*+,-./:;<=>?@\[\]^_`{|}~]$").hasMatch(this);
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(this);
    bool hasDigits = new RegExp(r'[0-9]').hasMatch(this);
    bool hasLowercase = new RegExp(r'[a-z]').hasMatch(this);
    bool hasSpecialCharacters = new RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);

    return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters;
  }

  bool isValidUsername() {
    return RegExp(r"^\w*[-._'+]*$").hasMatch(this);
  }
}