// NUMBER FORMAT : 123,456,789.04
String numberFormat(String number) {
  if (number.contains('.')) {
    var value = number.substring(0, number.indexOf('.'));
    var value2 = number.substring(number.indexOf('.'), number.length);

    if (value.length > 2) {
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value + value2;
    } else {
      return value + value2;
    }
  } else {
    if (number.length > 2) {
      number = number.replaceAll(RegExp(r'\D'), '');
      number = number.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return number;
    } else {
      return number;
    }
  }
}
