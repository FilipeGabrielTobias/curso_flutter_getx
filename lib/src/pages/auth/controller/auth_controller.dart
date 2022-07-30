import 'package:get/get.dart';
import 'package:greengrocer/src/constants/storage_keys.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/pages/auth/repository/auth_repository.dart';
import 'package:greengrocer/src/pages/auth/result/auth_result.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  UserModel userModel = UserModel();

  final authRepository = AuthRepository();
  final utilsServices = UtilsServices();

  @override
  void onInit() {
    super.onInit();
    validadeToken();
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;

    AuthResult result = await authRepository
        .signIn(email: email, password: password)
        .whenComplete(() => isLoading.value = false);

    result.when(
      success: (user) {
        userModel = user;
        saveTokenAndProceedToBase();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> signUp() async {
    isLoading.value = true;

    AuthResult result = await authRepository
        .signUp(userModel: userModel)
        .whenComplete(() => isLoading.value = false);

    result.when(
      success: (user) {
        userModel = user;
        saveTokenAndProceedToBase();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> validadeToken() async {
    // Recuperar o token que foi salvo localmente
    String? token = await utilsServices.getLocalData(key: StorageKeys.token);
    if (token == null) {
      Get.offAllNamed(PagesRoutes.signInRoute);
      return;
    }

    AuthResult result = await authRepository.validateToken(token);
    result.when(
      success: (user) {
        userModel = user;
        saveTokenAndProceedToBase();
      },
      error: (message) {
        signOut();
      },
    );
  }

  Future<void> signOut() async {
    // Limpar usuário
    userModel = UserModel();
    // Limpar token localmente
    await utilsServices.removeLocalData(key: StorageKeys.token);
    // Ir para login
    Get.offAllNamed(PagesRoutes.signInRoute);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;
    final result = await authRepository.changePassword(
      email: userModel.email!,
      currentPassword: currentPassword,
      newPassword: newPassword,
      token: userModel.token!,
    );
    isLoading.value = false;

    if (result) {
      utilsServices.showToast(
        message: 'A senha foi atualizada com sucesso!',
      );
      signOut();
    } else {
      utilsServices.showToast(
        message: 'A senha atual está incorreta',
        isError: true,
      );
    }
  }

  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }

  void saveTokenAndProceedToBase() {
    // Salvar o token
    utilsServices.saveLocalData(key: StorageKeys.token, data: userModel.token!);

    // Ir para a base
    Get.offAllNamed(PagesRoutes.baseRoute);
  }
}
