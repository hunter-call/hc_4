import 'dart:convert';
import 'package:flagsmith/flagsmith.dart';

class FlagService {
  static const String _apiKey = 'bMUkof98dJGWKA2tWHh8gr';

  late final FlagsmithClient _flagsmithClient;
  bool showWebView = false;
  Map<String, String> webViewConfig = {};

  Future<void> init() async {
    try {
      _flagsmithClient = await FlagsmithClient.init(
        apiKey: _apiKey,
        config: const FlagsmithConfig(
          caches: true,
        ),
      );

      await _flagsmithClient.getFeatureFlags(reload: true);

      String? appConfigString =
          await _flagsmithClient.getFeatureFlagValue('appconfig');

      if (appConfigString != null && appConfigString.isNotEmpty) {
        try {
          final configJson =
              jsonDecode(appConfigString) as Map<String, dynamic>;

          showWebView = configJson['showWebView'] as bool? ?? false;

          final wvc =
              configJson['webViewConfig'] as Map<String, dynamic>? ?? {};

          webViewConfig =
              wvc.map((key, value) => MapEntry(key, value.toString()));
        } catch (e) {
          showWebView = false;
          webViewConfig = {};
        }
      } else {
        showWebView = false;
        webViewConfig = {};
      }
    } catch (e) {
      showWebView = false;
      webViewConfig = {};
    }
  }

  /// Закрытие клиента Flagsmith
  void close() {
    _flagsmithClient.close();
  }
}
