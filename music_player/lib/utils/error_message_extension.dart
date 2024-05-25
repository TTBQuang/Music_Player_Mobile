extension ErrorMessageExtension on String {
  String extractErrorMessage() {
    String pref = 'Exception: ';
    if (startsWith(pref)) {
      return substring(pref.length);
    } else {
      return this;
    }
  }
}
