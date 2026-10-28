import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _instance = SecureStorageService._();
  factory SecureStorageService() => _instance;
  SecureStorageService._();

  final _store = const FlutterSecureStorage();

  static const _kUserToken = 'user_token';
  static const _kEmployeeId = 'employee_id';
  static const _kPinEnabled = 'pin_enabled';

  Future<void> saveUserSession(String employeeId, String token) async {
    await _store.write(key: _kEmployeeId, value: employeeId);
    await _store.write(key: _kUserToken, value: token);
  }

  Future<String?> getEmployeeId() => _store.read(key: _kEmployeeId);
  Future<String?> getUserToken() => _store.read(key: _kUserToken);

  Future<bool> isPinEnabled() async =>
      await _store.read(key: _kPinEnabled) == 'true';

  // Pemenuhan hak penghapusan data / logout total (PRV-03)
  Future<void> clearAll() => _store.deleteAll();
}
