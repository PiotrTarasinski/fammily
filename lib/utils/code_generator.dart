import 'dart:math';

class FamilyCodeGenerator {
  static String getRandomString(int length) {
    final _chars = 'QWERTYUIOPASDFGHJKLZXCVBNM1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static String generateCode() {
    String code = FamilyCodeGenerator.getRandomString(5);
    return code;
  }
}
