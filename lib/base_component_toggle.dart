import 'package:domain/models/component_action.dart';
import 'package:flutter/material.dart';

class BaseComponentToggle extends ComponentActionViewModel {
  BaseComponentToggle(
      BuildContext context, String currentIcon, String currentText) {
    _statusMessage = currentText;
    _currentIcon = currentIcon;
  }

  bool _isActive = false;
  @override
  bool get isActive => _isActive;

  @override
  String? get title => _statusMessage;

  String _currentIcon = "";
  @override
  String? get icon => _currentIcon;

  String? _statusMessage = "";
  @override
  String? get statusMessage => "";

  @override
  ready() async {
    return super.ready();
  }

  @override
  onPresssed() {
    notifyListeners();
  }
}
