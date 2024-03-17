import 'package:components/biometric_panel/biometric_panel.dart';
import 'package:components/pattern_panel/pattern_panel.dart';
import 'package:components/pin_code_panel/pin_code_panel.dart';
import 'package:domain/exceptions/base_exception.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/interfaces/iauthorization_service.dart';
import 'package:shared/page_view_model.dart';
import 'package:domain/models/enums.dart';

class UnlockPanelViewModel extends PageViewModel {
  late IAuthorizationService _authorizationService;

  bool _isWrongToken = false;
  bool get isWrongPassword => _isWrongToken;

  Widget _lockOption = const Column();
  Widget get lockOption => _lockOption;

  UnlockPanelViewModel(super.context) {
    _authorizationService = getIt.get<IAuthorizationService>();
    observer.subscribe("unlock_failed", onUnlockFailed);
  }

  ready() async {
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

  onUnlockFailed() {
    _isWrongToken = true;
    notifyListeners();
  }

  @override
  void dispose() {
    observer.dispose("unlock_failed");
    super.dispose();
  }
}
