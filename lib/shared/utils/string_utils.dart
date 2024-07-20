import 'dart:math';

class StringUtils {
  static String generatedID() {
    String characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String id = '';

    for (int i = 0; i < characters.length; i++) {
      int randomIndex = random.nextInt(characters.length);
      id += characters[randomIndex];
    }

    return id;
  }
}
