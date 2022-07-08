import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../../theme/theme.dart';
import '../../../widgets/irma_app_bar.dart';
import '../../../widgets/logo_banner.dart';

class LogoBannerHeader extends StatelessWidget {
  final Image logo;
  final String header;
  final Color backgroundColor;
  final Color textColor;
  final Widget bottomBar;
  final Widget child;
  final void Function() onBack;
  final GlobalKey scrollviewKey;
  final ScrollController controller;

  const LogoBannerHeader({
    required this.logo,
    required this.header,
    required this.backgroundColor,
    required this.textColor,
    required this.bottomBar,
    required this.child,
    required this.scrollviewKey,
    required this.controller,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IrmaAppBar(
        titleTranslationKey: 'issue_wizard.add_cards',
        leadingAction: onBack,
        leadingIcon: Icon(
          Icons.arrow_back,
          semanticLabel: FlutterI18n.translate(context, 'accessibility.back'),
        ),
      ),
      bottomNavigationBar: bottomBar,
      body: SingleChildScrollView(
        controller: controller,
        key: scrollviewKey,
        child: Column(
          children: [
            LogoBanner(
              text: header,
              logo: logo,
              backgroundColor: backgroundColor,
              textColor: textColor,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: IrmaTheme.of(context).mediumSpacing,
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
