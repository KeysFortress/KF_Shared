import 'package:components/biometric_panel/biometric_panel.dart';
import 'package:components/pattern_panel/pattern_panel.dart';
import 'package:components/pin_code_panel/pin_code_panel.dart';
import 'package:domain/exceptions/base_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infrastructure/interfaces/iauthorization_service.dart';
import 'package:infrastructure/interfaces/ilocal_storage.dart';
import 'package:shared/page_view_model.dart';
import 'package:domain/models/enums.dart';

class UnlockPanelViewModel extends PageViewModel {
  late IAuthorizationService _authorizationService;
  late IlocalStorage _localStorage;

  bool _isWrongToken = false;
  bool get isWrongPassword => _isWrongToken;

  Widget _lockOption = const Column();
  Widget get lockOption => _lockOption;

  bool _isSelfDestructActivated = false;
  bool get isSelfDestructEnabled => _isSelfDestructActivated;
  int _remainingAttempts = 3;
  int get remainingAttempts => _remainingAttempts;

  UnlockPanelViewModel(super.context) {
    _authorizationService = getIt.get<IAuthorizationService>();
    _localStorage = getIt.get<IlocalStorage>();
    observer.subscribe("unlock_failed", onUnlockFailed);
  }

  ready() async {
    _isSelfDestructActivated =
        await _authorizationService.selfDestructActivated();
    if (_isSelfDestructActivated) {
      _remainingAttempts = await _authorizationService.getSelfDestructAttemts();
    }

    var lockType = await _authorizationService.getDeviceLockType();
    switch (lockType) {
      case DeviceLockType.password:
        _lockOption = const PinCodePanel();
      case DeviceLockType.pattern:
        _lockOption = const PatternPanel();
      case DeviceLockType.biometric:
        _lockOption = const BiometricPanel();
        break;
      case DeviceLockType.none:
        // ignore: use_build_context_synchronously
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            router.router.router.go("/setup-lock");
          },
        );
        break;
      case DeviceLockType.totp:
        // ignore: use_build_context_synchronously
        throw BaseException(context: pageContext, message: "Not implemented");
    }
    notifyListeners();
  }

  onTryAgain() {
    _isWrongToken = false;
    notifyListeners();
  }

  onUnlockFailed() async {
    _isWrongToken = true;
    _remainingAttempts = _remainingAttempts - 1;
    if (_remainingAttempts == 0) {
      await _localStorage.wipeData();

      // I KNOW IT"S STUPID NAMING, will fix it, when i get time.
      router.router.router.go("/");
    }
    notifyListeners();
  }

  @override
  void dispose() {
    observer.dispose("unlock_failed");
    super.dispose();
  }
}
