import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../widgets/irma_app_bar.dart';

class SessionScaffold extends StatelessWidget {
  final Widget? body, bottomNavigationBar;
  final String appBarTitle;
  final VoidCallback? onDismiss;

  const SessionScaffold({
    Key? key,
    this.onDismiss,
    this.bottomNavigationBar,
    this.body,
    required this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = IrmaTheme.of(context);
    return Scaffold(
      backgroundColor: theme.background,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
      appBar: IrmaAppBar(
        titleTranslationKey: appBarTitle,
        leadingAction: onDismiss,
      ),
    );
  }
}
