import 'dart:developer';

class Validator {
  static String? validate(String ruleString, String value) {
    List <String> rules = ruleString.split('|');

    for (String rule in rules) {
      List <String> ruleRes = rule.split(':');

      switch (ruleRes[0]) {
        case 'password':
          if (value.isEmpty || value.isValidPassword()) {
            break;
          }

          return 'Неверный формат пароля';
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
        case 'required':
          if (value.isEmpty) {
            return 'Пустое поле';
          }

          break;
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

  bool isValidPassword() {
    // return RegExp(r"^[a-z][A-Z][!#$%&'()*+,-./:;<=>?@\[\]^_`{|}~]$").hasMatch(this);
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(this);
    bool hasDigits = RegExp(r'[0-9]').hasMatch(this);
    bool hasLowercase = RegExp(r'[a-z]').hasMatch(this);
    bool hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);
    bool notHasSpaces = this.notHasSpaces();

    return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & notHasSpaces;
  }

  bool isValidUsername() {
    return RegExp(r"^\w*[-._'+]*$").hasMatch(trim()) & notHasSpaces();
  }
}