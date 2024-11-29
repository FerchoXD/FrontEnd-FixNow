import 'package:fixnow/domain/entities/user.dart';
import 'package:fixnow/infrastructure/datasources/auth_user.dart';
import 'package:fixnow/infrastructure/services/key_value_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated,
  newUserRegistred,
  accountActivated
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authUser = AuthUser();
  final keyValueStorage = KeyValueStorage();

  return AuthNotifier(authUser: authUser, keyValueStorage: keyValueStorage);
});

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String message;
  final List userTemp;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.message = '',
      this.userTemp = const []});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? message,
    List? userTemp,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        message: message ?? this.message,
        userTemp: userTemp ?? this.userTemp,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthUser authUser;
  final KeyValueStorage keyValueStorage;

  AuthNotifier({required this.authUser, required this.keyValueStorage})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final userTemp = await authUser.login(email, password);
      final token = userTemp['token'];
      _setLoggedUser(token);
    } catch (error) {
      logout();
    }
  }

  void registerUser(String name, String lastName, String email,
      String phoneNumber, String password, String role) async {
    try {
      await authUser.register(
          name, lastName, email, phoneNumber, password, role);
      state = state.copyWith(authStatus: AuthStatus.newUserRegistred);
    } catch (error) {
      logout();
    }
  }

  void activateAccount(String code) async {
    try {
      final user = await authUser.activateAccount(code);
      state =
          state.copyWith(authStatus: AuthStatus.accountActivated, user: user);
    } catch (e) {
      throw Error();
    }
  }

  void checkAuthStatus() async {
    final token = await keyValueStorage.getValue('token');
    if (token == null) return logout();
    try {
      await _setLoggedUser(token);
    } catch (error) {
      logout();
    }
  }

  _setLoggedUser(String token) async {
    await keyValueStorage.setValueKey('token', token);
    final user = await _getUserProfile();
    state = state.copyWith(
      user: user,
      userTemp: null,
      authStatus: AuthStatus.authenticated,
      message: '',
    );
  }

  Future _getUserProfile() async {
    try {
      final token = await keyValueStorage.getValue('token');
      if (token == null) return logout();
      final user = await authUser.getUser(token);
      print(user);
      return user;
    } catch (e) {
      logout();
      throw Error();
    }
  }

  Future<void> logout() async {
    await keyValueStorage.removeKey('token');
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      // message: message);
    );
  }
}
