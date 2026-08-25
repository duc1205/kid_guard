class MoneyFormat {
  static String vnd(int amount) {
    final s = amount.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write('.');
    }
    final formatted = buf.toString();
    return amount < 0 ? '-$formatted₫' : '$formatted₫';
  }

  static String compact(int amount) {
    final a = amount.abs();
    final String body;
    if (a >= 1000000000) {
      body = '${_trim(a / 1000000000)} tỷ';
    } else if (a >= 1000000) {
      body = '${_trim(a / 1000000)}tr';
    } else if (a >= 1000) {
      body = '${_trim(a / 1000)}k';
    } else {
      body = '$a';
    }
    return amount < 0 ? '-$body' : body;
  }

  static String compactRange(int minVnd, int maxVnd) =>
      '${compact(minVnd)} – ${compact(maxVnd)}';

  static String range(int minVnd, int maxVnd) =>
      '${vnd(minVnd)} – ${vnd(maxVnd)}';

  static String _trim(double v) {
    if (v >= 100) return v.toStringAsFixed(0);
    return v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1);
  }
}
