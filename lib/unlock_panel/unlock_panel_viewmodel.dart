import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared/page_view_model.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class UnlockPanelViewModel extends PageViewModel {
  final LocalAuthentication auth = LocalAuthentication();
  UnlockPanelViewModel(super.context);

  ready() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(useErrorDialogs: false));
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
