import 'package:components/biometric_panel/biometric_panel.dart';
import 'package:components/pattern_panel/pattern_panel.dart';
import 'package:components/pin_code_panel/pin_code_panel.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/interfaces/iauthorization_service.dart';
import 'package:infrastructure/interfaces/ipage_router_service.dart';
import 'package:shared/page_view_model.dart';
import 'package:domain/models/enums.dart';
import 'package:components/fill_totp_code/fill_totp_code.dart';

class UnlockPanelViewModel extends PageViewModel {
  late IAuthorizationService _authorizationService;
  late IPageRouterService _routerService;

  Widget _lockOption = const Column();
  Widget get lockOption => _lockOption;

  UnlockPanelViewModel(super.context) {
    _authorizationService = getIt.get<IAuthorizationService>();
    _routerService = getIt.get<IPageRouterService>();
  }

  ready() async {
    var lockType = await _authorizationService.getDeviceLockType();
    switch (lockType) {
      case DeviceLockType.password:
        _lockOption = const PinCodePanel();
      case DeviceLockType.pattern:
        _lockOption = const PatternPanel();
      case DeviceLockType.totp:
        _lockOption = const FillTotpCode();
        break;
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
    }
    notifyListeners();
  }
}
