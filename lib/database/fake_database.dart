class FakeDatabase {
  Future<bool> connectDatabase() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
