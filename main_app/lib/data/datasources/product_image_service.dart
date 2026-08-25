import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/valued_item.dart';

/// Cache URL ảnh minh họa + tìm ảnh từ Wikipedia/Wikimedia.
class ProductImageService {
  ProductImageService._();

  static const _prefsKey = 'product_image_url_cache_v1';
  static final Map<String, String?> _memory = {};
  static Map<String, String>? _disk;
  static Future<void>? _loadingDisk;

  static Future<ValuationResult> enrich(ValuationResult result) async {
    final items = await Future.wait(
      result.items.map((item) async {
        if (item.imageUrl.trim().isNotEmpty) return item;
        final url = await findUrl(item);
        return item.copyWith(imageUrl: url ?? '');
      }),
    );
    return result.copyWith(items: items);
  }

  static Future<String?> findUrl(ValuedItem item) async {
    final query = item.effectiveSearchQuery;
    if (query.isEmpty) return null;

    final cached = await _readCache(query);
    if (cached != null) {
      return cached.isEmpty ? null : cached;
    }

    final url = await _fromWikipedia(query) ??
        await _fromWikipedia(
          item.nameEn.isNotEmpty ? item.nameEn : item.nameVi,
        ) ??
        await _fromCommons(query);

    await _writeCache(query, url ?? '');
    return url;
  }

  static Future<String?> _readCache(String query) async {
    if (_memory.containsKey(query)) return _memory[query];
    await _ensureDisk();
    final v = _disk![query];
    if (v != null) {
      _memory[query] = v.isEmpty ? null : v;
      return _memory[query];
    }
    return null;
  }

  static Future<void> _writeCache(String query, String url) async {
    _memory[query] = url.isEmpty ? null : url;
    await _ensureDisk();
    _disk![query] = url;
    final prefs = await SharedPreferences.getInstance();
    // Giới hạn 200 entry gần nhất
    if (_disk!.length > 200) {
      final keys = _disk!.keys.toList();
      for (final k in keys.take(_disk!.length - 200)) {
        _disk!.remove(k);
      }
    }
    await prefs.setString(_prefsKey, jsonEncode(_disk));
  }

  static Future<void> _ensureDisk() {
    return _loadingDisk ??= () async {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) {
        _disk = {};
        return;
      }
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          _disk = decoded.map(
            (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
          );
        } else {
          _disk = {};
        }
      } catch (_) {
        _disk = {};
      }
    }();
  }

  static Future<String?> _fromWikipedia(String query) async {
    try {
      final uri = Uri.https('en.wikipedia.org', '/w/api.php', {
        'action': 'query',
        'generator': 'search',
        'gsrsearch': query,
        'gsrlimit': '1',
        'prop': 'pageimages',
        'piprop': 'thumbnail',
        'pithumbsize': '640',
        'format': 'json',
        'origin': '*',
      });
      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final pages = data['query']?['pages'];
      if (pages is! Map) return null;
      for (final page in pages.values) {
        if (page is Map && page['thumbnail'] is Map) {
          final src = page['thumbnail']['source'];
          if (src is String && src.isNotEmpty) return src;
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> _fromCommons(String query) async {
    try {
      final uri = Uri.https('commons.wikimedia.org', '/w/api.php', {
        'action': 'query',
        'generator': 'search',
        'gsrsearch': 'filetype:bitmap $query',
        'gsrnamespace': '6',
        'gsrlimit': '1',
        'prop': 'imageinfo',
        'iiprop': 'url',
        'iiurlwidth': '640',
        'format': 'json',
        'origin': '*',
      });
      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final pages = data['query']?['pages'];
      if (pages is! Map) return null;
      for (final page in pages.values) {
        if (page is! Map) continue;
        final infos = page['imageinfo'];
        if (infos is List && infos.isNotEmpty) {
          final info = infos.first;
          if (info is Map) {
            final thumb = info['thumburl'] ?? info['url'];
            if (thumb is String && thumb.isNotEmpty) return thumb;
          }
        }
      }
    } catch (_) {}
    return null;
  }
}
