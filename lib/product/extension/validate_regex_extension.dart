extension ValidateRegexExtension on String {
  //email
  bool get isEmail => RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      ).hasMatch(this);
//tel number
  bool get isPhone =>
      RegExp(r'^[(]5[0-9]{2}[)]\s[0-9]{3}\s[0-9]{2}\s[0-9]{2}$').hasMatch(this);
//tel number 2
  bool get isLoginPhone => RegExp(r'^5[0-9]{9}$').hasMatch(this);
//url
  bool get isUrl =>
      RegExp(r'^(http(s)?:\/\/)?((w){3}.)?youtu(be|.be)?(\.com)?\/.+')
          .hasMatch(this);
  //date
  bool get isDate => RegExp(r'^[1-9]{4}-[0-9]{2}-[0-9]{2}$').hasMatch(this);
  //time
  bool get isTime =>
      RegExp(r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$').hasMatch(this);
  //datetime
  bool get isDateTime =>
      RegExp(r'^[1-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$')
          .hasMatch(this);
  //number
  bool get isNumber => RegExp(r'^[0-9]+$').hasMatch(this);
  //int
  bool get isInteger => RegExp(r'^[0-9]+$').hasMatch(this);
  //double
  bool get isDouble => RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(this);
  //namesurname
  bool get isNameSurname => RegExp(r'^[a-zA-ZüğşıöçĞÜŞİÖÇ\s]+$').hasMatch(this);
  //username
  bool get username => RegExp(r'^[a-zA-ZüğşıöçĞÜŞİÖÇ\s]+$').hasMatch(this);
  //r'^[a-zA-ZĞÜŞİÖÇğüşıöç\s]+$')
  //credit card
  bool get creditCard =>
      RegExp(r'^([0-9]{4})([0-9]{4})([0-9]{4})([0-9]{4})$').hasMatch(this);
  //cvv
  bool get cvv => RegExp(r'^[0-9]{3,4}$').hasMatch(this);
  //address
  bool get address =>
      RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s0-9.:\/]+$').hasMatch(this);

  //* tc
  bool isTC(String input) {
    RegExp regex = RegExp(
        r'^[1-9]{1}[0-9]{9}[02468]{1}$'); // TC kimlik numarası için regular expression deseni
    if (!regex.hasMatch(input)) return false;

    int sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(input.substring(i, i + 1));
    }
    int digit11 = sum % 10;

    int oddSum = 0;
    for (int i = 0; i < 9; i = i + 2) {
      // 0,2,4,6,8 (1,3,5,7,9)
      oddSum += int.parse(input.substring(i, i + 1));
    }
    int evenSum = 0;
    for (int i = 1; i < 9; i = i + 2) {
      //1,3,5,7  (2,4,6,8)
      evenSum += int.parse(input.substring(i, i + 1));
    }
    int digit10 = (oddSum * 7) - evenSum;
    digit10 = digit10 % 10;

    if (digit11 != int.parse(input.substring(10, 11)) ||
        digit10 != int.parse(input.substring(9, 10))) {
      return false;
    }
    return true;
  }

  //* parola
  bool isPassword(String password) {
    RegExp regex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$'); //=> en az 8 karakter en fazla 16 karakter olarak ayarlandı (?=.*?[!@#\.$&+*~])
    return regex.hasMatch(password);
  }

  //* parola tekrar
  bool isRepeartPassword(String password, String confirmPassword) {
    RegExp regex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$'); //=> en az 8 karakter en fazla 16 karakter olarak ayarlandı (?=.*?[!@#\.$&+*~])
    if (!regex.hasMatch(password)) {
      return false;
    }
    if (password != confirmPassword) {
      return false;
    }
    return true;
  }
}
