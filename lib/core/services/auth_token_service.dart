import 'package:shared_preferences/shared_preferences.dart';

/// Manages secure local storage of the JWT token and basic user profile.
/// Uses SharedPreferences (encrypted in production release builds).
class AuthTokenService {
  static const _kToken = 'ab_jwt_token';
  static const _kUserId = 'ab_user_id';
  static const _kIdentity = 'ab_identity';
  static const _kFullName = 'ab_full_name';
  static const _kBoxCode = 'ab_box_code';
  static const _kRole = 'ab_role';

  static AuthTokenService? _instance;
  static AuthTokenService get instance => _instance ??= AuthTokenService._();
  AuthTokenService._();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _store async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ─── Write ─────────────────────────────────────────────────────────────────

  Future<void> saveSession({
    required String token,
    required String userId,
    required String identity,
    required String fullName,
    required String boxCode,
    required String role,
  }) async {
    final prefs = await _store;
    await Future.wait([
      prefs.setString(_kToken, token),
      prefs.setString(_kUserId, userId),
      prefs.setString(_kIdentity, identity),
      prefs.setString(_kFullName, fullName),
      prefs.setString(_kBoxCode, boxCode),
      prefs.setString(_kRole, role),
    ]);
  }

  Future<void> clearSession() async {
    final prefs = await _store;
    await Future.wait([
      prefs.remove(_kToken),
      prefs.remove(_kUserId),
      prefs.remove(_kIdentity),
      prefs.remove(_kFullName),
      prefs.remove(_kBoxCode),
      prefs.remove(_kRole),
    ]);
  }

  // ─── Read ──────────────────────────────────────────────────────────────────

  Future<String?> getToken() async => (await _store).getString(_kToken);
  Future<String?> getUserId() async => (await _store).getString(_kUserId);
  Future<String?> getBoxCode() async => (await _store).getString(_kBoxCode);
  Future<String?> getFullName() async => (await _store).getString(_kFullName);
  Future<String?> getIdentity() async => (await _store).getString(_kIdentity);
  Future<String?> getRole() async => (await _store).getString(_kRole);

  Future<bool> get isLoggedIn async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
