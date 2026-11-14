import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/presentation/l10n_ext.dart';

void main() {
  group('chọn ngôn ngữ theo máy', () {
    test('máy tiếng Việt → vi', () {
      expect(resolveAppLocale(const [Locale('vi', 'VN')]), const Locale('vi'));
    });
    test('máy tiếng Anh → en', () {
      expect(resolveAppLocale(const [Locale('en', 'US')]), const Locale('en'));
    });
    test('ngôn ngữ chưa hỗ trợ → en', () {
      expect(resolveAppLocale(const [Locale('ja', 'JP')]), const Locale('en'));
      expect(resolveAppLocale(null), const Locale('en'));
    });
    test('ưu tiên theo thứ tự ngôn ngữ của máy', () {
      expect(
        resolveAppLocale(const [Locale('fr'), Locale('vi')]),
        const Locale('vi'),
      );
    });
  });

  test('app_en.arb và app_vi.arb có cùng bộ key và placeholder', () {
    Map<String, dynamic> load(String f) =>
        jsonDecode(File('lib/l10n/$f').readAsStringSync())
            as Map<String, dynamic>;
    final en = load('app_en.arb'), vi = load('app_vi.arb');
    Set<String> keys(Map<String, dynamic> m) =>
        m.keys.where((k) => !k.startsWith('@')).toSet();
    expect(keys(vi), keys(en));

    final placeholder = RegExp(r'\{(\w+)[,}]');
    for (final k in keys(en)) {
      final pe = placeholder
          .allMatches(en[k] as String)
          .map((m) => m[1])
          .toSet();
      final pv = placeholder
          .allMatches(vi[k] as String)
          .map((m) => m[1])
          .toSet();
      expect(pv.difference(pe), isEmpty, reason: '$k: placeholder lạ trong vi');
    }
  });

  testWidgets('định dạng thời lượng theo ngôn ngữ', (tester) async {
    late AppLocalizations en, vi;
    await tester.pumpWidget(
      Localizations(
        locale: const Locale('en'),
        delegates: AppLocalizations.localizationsDelegates,
        child: Builder(
          builder: (c) {
            en = c.l10n;
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpWidget(
      Localizations(
        locale: const Locale('vi'),
        delegates: AppLocalizations.localizationsDelegates,
        child: Builder(
          builder: (c) {
            vi = c.l10n;
            return const SizedBox();
          },
        ),
      ),
    );
    const d = Duration(hours: 1, minutes: 5);
    expect(en.duration(d), '1 h 5 min');
    expect(vi.duration(d), '1 giờ 5 phút');
    expect(en.duration(const Duration(minutes: 1)), '1 minute');
    expect(vi.duration(const Duration(seconds: 40)), '40 giây');
  });
}
