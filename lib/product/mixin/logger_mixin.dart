mixin LoggerMixin {
  void log(String message) {
    final timeStamp = DateTime.now();
    print('[$timeStamp] $message');
  }
}
