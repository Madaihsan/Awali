import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  final _store = const FlutterSecureStorage();
  final _kdf = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 120000,
    bits: 256,
  );

  Future<String> _hash(String pin, List<int> salt) async {
    final key = await _kdf.deriveKeyFromPassword(
      password: pin,
      nonce: salt,
    );
    return base64Encode(await key.extractBytes());
  }

  Future<void> setPin(String pin) async {
    final salt = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    await _store.write(key: 'pin_salt', value: base64Encode(salt));
    await _store.write(key: 'pin_hash', value: await _hash(pin, salt));
    await _store.write(key: 'pin_enabled', value: 'true');
  }

  Future<bool> verifyPin(String pin) async {
    final s = await _store.read(key: 'pin_salt');
    final h = await _store.read(key: 'pin_hash');
    if (s == null || h == null) return false;

    final actual = await _hash(pin, base64Decode(s));
    return _sameConstantTime(actual, h);
  }

  Future<void> removePin() async {
    await _store.delete(key: 'pin_hash');
    await _store.delete(key: 'pin_salt');
    await _store.write(key: 'pin_enabled', value: 'false');
  }

  // Mencegah timing attack dengan membandingkan string dalam waktu konstan
  bool _sameConstantTime(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
