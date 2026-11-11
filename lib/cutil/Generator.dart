class Generator {
  static Generator instance = Generator();

  Generator();

  static int _currentValue = 0;
  Future<int> generateId() async {
    _currentValue += 1;
    return Future.value(_currentValue);
  }
}
