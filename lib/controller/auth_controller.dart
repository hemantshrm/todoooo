

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class AuthController extends GetxController {
  var _locaAuth = LocalAuthentication();
  var hasFingerPrintLock = false.obs;
  var hasFaceLock = false.obs;
  var isUserAuthenticated = false.obs;

  void _getAllBiometrics() async {
    bool hasLocalAuth = await _locaAuth.canCheckBiometrics;
    if (hasLocalAuth) {
      List<BiometricType> availableBiometrics =
          await _locaAuth.getAvailableBiometrics();
      hasFaceLock.value = availableBiometrics.contains(BiometricType.face);
      hasFingerPrintLock.value =
          availableBiometrics.contains(BiometricType.fingerprint);
    } else {
      Get.snackbar("Error", "User Not Identified",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onInit() {
    _getAllBiometrics();
    super.onInit();
  }

  authenticateUser() async {
    try {
      const androidMessage = const AndroidAuthMessages(
          biometricHint: "Verify your Identity",
          goToSettingsButton: "Setting",
          goToSettingsDescription: "Please setup your Fingerprint/Face");
      isUserAuthenticated.value = await _locaAuth.authenticate(
          localizedReason: "Authenticate Yourself",
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
          androidAuthStrings: androidMessage,
          iOSAuthStrings: IOSAuthMessages(
            goToSettingsDescription: "Please setup your Fingerprint/Face",
            goToSettingsButton: "Setting",
          ));

      return isUserAuthenticated.value;
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
