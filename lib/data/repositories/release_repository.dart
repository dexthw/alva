import 'package:shared_preferences/shared_preferences.dart';

/// Guarda a última versão cuja tela "O que há de novo" já foi exibida.
class ReleaseRepository {
  ReleaseRepository({SharedPreferences? prefs}) : _prefs = prefs;

  static const String seenVersionKey = 'alva.last_seen_version';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<String?> seenVersion() async {
    try {
      final SharedPreferences prefs = await _instance;
      return prefs.getString(seenVersionKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> markSeen(String version) async {
    try {
      final SharedPreferences prefs = await _instance;
      await prefs.setString(seenVersionKey, version);
    } catch (_) {
      // Falha de escrita não deve impedir o uso do app.
    }
  }

  Future<void> clear() async {
    try {
      final SharedPreferences prefs = await _instance;
      await prefs.remove(seenVersionKey);
    } catch (_) {
      // Idem.
    }
  }
}
