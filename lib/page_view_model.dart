import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:infrastructure/interfaces/iobserver.dart';
import 'package:infrastructure/interfaces/ipage_router_service.dart';
import 'package:localization/localization.dart';
import 'package:stacked/stacked.dart';
import 'package:shared/locator.dart' as locator;
import 'package:infrastructure/interfaces/iauthorization_service.dart';

class PageViewModel extends BaseViewModel {
  GetIt getIt = locator.getIt;
  late BuildContext pageContext;
  late IPageRouterService router = locator.getIt.get<IPageRouterService>();
  late IObserver observer = locator.getIt.get<IObserver>();
  late IAuthorizationService authorizationService =
      locator.getIt.get<IAuthorizationService>();

  PageViewModel(BuildContext context) {
    FocusScope.of(context).unfocus();
    pageContext = context;

    // You can now use the context inside the ViewModel if needed
    FocusManager.instance.primaryFocus?.unfocus();
  }

  onLanaugeChanged(String locale) {
    locale = "en_$locale";
    LocalJsonLocalization.delegate.load(Locale(locale));
    notifyListeners();
  }
}
