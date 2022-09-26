import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_u/src/features/auth/data/auth_repository.dart';
import 'package:quiz_u/src/utils/app_http_client.dart';

class AuthService {
  AuthService({required this.authRepository, required this.client});
  final AuthRepository authRepository;
  final AppHttpClient client;

  /// This intialization function should be called during splash screen
  ///
  /// Once this function is done, we can decide where to go
  Future<void> initialize() async {
    // read persistent token
    final token = await readPersistentToken();
    // if it exists
    if (token != null) {
      // validate it
      // 1. First include it in the [AppHttpClient] instance
      client.accessToken = token;
      // 2. then try it out
      final isTokenValid = await authRepository.checkToken();
      // if it is valid, get user info and update user, and update client
      if (isTokenValid) {
        await authRepository.getUserInfo();
      }
      // if it is not valid, ask user to login again
      // this can be achieved by the router
      // which will automatically redirect the user to main auth screen
    }
    // if it does not exist, ask user to login
    // this can also be achieved by the router
    // which will automatically redirect the user to main auth screen
  }

  Future<void> submitMobile(String mobile) =>
      authRepository.submitMobile(mobile);

  Future<void> submitOtp({required String otp}) async {
    final token = await authRepository.submitOtp(otp: otp);
    // Save token into the [AppHttpClient]
    client.accessToken = token;
    // Save token in persistent secure storage
    await updatePersistentToken(token);
    // Now it is a good time to check wether user has a name or not
    // Just call userInfo and update [LoggedInUser]
    await authRepository.getUserInfo();
  }

  Future<void> submitName(String name) => authRepository.submitName(name);

  Future<void> logout() async {
    // call logout in [AuthRepository]
    await authRepository.logout();
    // delete [token] from [AppHttpClient]
    client.accessToken = null;
    // remove persistent token by setting it to null
    updatePersistentToken(null);
  }

  Future<void> updatePersistentToken(String? token) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
  }

  Future<String?> readPersistentToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final client = ref.watch(appHttpClientProvider);
  return AuthService(authRepository: authRepository, client: client);
});
