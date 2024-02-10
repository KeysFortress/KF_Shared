import 'package:components/pin_code_panel/pin_code_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infrastructure/interfaces/iauthorization_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared/page_view_model.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:domain/models/enums.dart';
import 'package:domain/models/transition_data.dart';

class UnlockPanelViewModel extends PageViewModel {
  late IAuthorizationService _authorizationService;
  final LocalAuthentication auth = LocalAuthentication();

  Widget _lockOption = const Column();
  Widget get lockOption => _lockOption;

  UnlockPanelViewModel(super.context) {
    _authorizationService = getIt.get<IAuthorizationService>();
  }

  ready() async {
    var lockType = await _authorizationService.getDeviceLockType();
    switch (lockType) {
      case DeviceLockType.password:
        _lockOption = const PinCodePanel();
      case DeviceLockType.pattern:
      case DeviceLockType.totp:
        break;

      case DeviceLockType.biometric:
        await requestBiometric();
        break;
      case DeviceLockType.none:
        // ignore: use_build_context_synchronously
        router.changePage(
          "/setup-lock",
          pageContext,
          TransitionData(next: PageTransition.slideForward),
        );
        break;
    }
    notifyListeners();
  }

  Future requestBiometric() async {
    try {
      await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(useErrorDialogs: false),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        // Add handling of no hardware here.
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        // ...
      } else {
        // ...
      }
    }
  }
}
