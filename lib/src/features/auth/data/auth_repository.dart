import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/auth/domain/logged_user.dart';
import 'package:quiz_u/src/utils/api_end_points.dart';
import 'package:quiz_u/src/utils/app_http_client.dart';
import 'package:quiz_u/src/utils/in_memory_store.dart';

class AuthRepository {
  AuthRepository(this._client);

  /// The [HttpClient] this repository will use
  final AppHttpClient _client;

  final _authState = InMemoryStore<LoggedUser?>(null);

  LoggedUser? get currentUser => _authState.value;

  Stream<LoggedUser?> authStateChanges() => _authState.stream;

  void setUser(LoggedUser user) {
    _authState.value = user;
  }

  bool get isValidUser =>
      (currentUser?.name?.isNotEmpty ?? false) &&
      (currentUser?.mobile.isNotEmpty ?? false);

  Future<bool> checkToken() async {
    final response = await _client.get(Uri.parse(Endpoints.token));
    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['success'] is bool) {
      return jsonResponse['success'];
    } else {
      throw 'Could not check token validity';
    }
  }

  /// This function should be called when user enters mobile number
  /// From the backend side, an OTP should be sent to user
  ///
  /// And since there is no API for this and OTP is defaulted to 0000,
  /// this API will be simulated with just a delay
  Future<void> submitMobile(String mobile) async {
    _authState.value = LoggedUser('', mobile);
    return Future.delayed(const Duration(seconds: 1));
  }

  Future<String> submitOtp({required String otp}) async {
    try {
      if (_authState.value?.mobile == null) {
        throw 'No mobile is saved for this user';
      }
      // call sign in endpoint
      final response = await _client.post(Uri.parse(Endpoints.login), body: {
        'OTP': otp,
        'mobile': _authState.value!.mobile,
      });
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 201 && jsonResponse['success']) {
        // save user info in _authState
        _authState.value = LoggedUser.fromJson(jsonResponse);

        // return token to [AuthService] to persist it
        return jsonResponse['token'];
      } else {
        throw jsonResponse['message'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> submitName(String name) async {
    try {
      // call Name Endpoint
      final response = await _client
          .post(Uri.parse(Endpoints.updateName), body: {'name': name});
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 201 && jsonResponse['success']) {
        // save user info in _authState
        _authState.value = LoggedUser.fromJson(jsonResponse);
      } else {
        throw 'Could not update user name';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getUserInfo() async {
    try {
      // call Name Endpoint
      final response = await _client.get(Uri.parse(Endpoints.userInfo));
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // save user info in _authState
        _authState.value = LoggedUser.fromJson(jsonResponse);
      } else {
        throw 'Could not get user info';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    // call log out endpoint, but since there is no actual logout endpoint,
    // we just put a fake delay
    await Future.delayed(const Duration(seconds: 1));
    // update user info to null
    _authState.value = null;
  }

  void dispose() => _authState.close();
}

/// A provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(appHttpClientProvider);
  final auth = AuthRepository(client);
  ref.onDispose(() => auth.dispose());
  return auth;
});

/// A stream provider to watch authState changes
final authStateChangesProvider = StreamProvider<LoggedUser?>((ref) {
  // we need to depend on authProvider
  // so when any change happen in AuthRepository, this stream provider gets updated
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
