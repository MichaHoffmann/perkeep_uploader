class NumberFormatter {
  static String humanReadableBytes(int value) {
    if (value < 1000) {
      // less than a million
      return "${value.toStringAsFixed(0)}B";
    } else if (value >= 1000 && value < 1000000) {
      // less than a million
      double result = value / 1000;
      return "${result.toStringAsFixed(2)}KiB";
    } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
      // less than 100 million
      double result = value / 1000000;
      return "${result.toStringAsFixed(2)}MiB";
    } else if (value >= (1000000 * 10 * 100) &&
        value < (1000000 * 10 * 100 * 100)) {
      // less than 100 billion
      double result = value / (1000000 * 10 * 100);
      return "${result.toStringAsFixed(2)}GiB";
    } else if (value >= (1000000 * 10 * 100 * 100) &&
        value < (1000000 * 10 * 100 * 100 * 100)) {
      // less than 100 trillion
      double result = value / (1000000 * 10 * 100 * 100);
      return "${result.toStringAsFixed(2)}TiB";
    }
    return "${value}B";
  }
}
