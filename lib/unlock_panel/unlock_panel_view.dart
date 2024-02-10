import 'package:flutter/material.dart';
import 'package:shared/unlock_panel/unlock_panel_viewmodel.dart';
import 'package:stacked/stacked.dart';

class UnlockPanelView extends StatelessWidget {
  const UnlockPanelView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => UnlockPanelViewModel(context),
      onViewModelReady: (viewModel) => viewModel.ready(),
      builder: (context, viewModel, child) => viewModel.lockOption,
    );
  }
}
