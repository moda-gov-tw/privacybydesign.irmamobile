import 'package:flutter/material.dart';

import '../../theme/irma_icons.dart';
import '../../theme/theme.dart';
import '../../widgets/translated_text.dart';
import '../activity/widgets/recent_activity.dart';
import '../scanner/scanner_screen.dart';
import 'widgets/irma_action_card.dart';
import 'widgets/irma_info_card.dart';
import 'widgets/irma_nav_bar.dart';

class HomeTab extends StatelessWidget {
  final Function(IrmaNavBarTab tab) onChangeTab;

  const HomeTab({
    required this.onChangeTab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = IrmaTheme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: theme.mediumSpacing,
        horizontal: theme.defaultSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Tab title
          TranslatedText(
            'home_tab.title',
            style: theme.textTheme.headline2,
          ),
          SizedBox(height: theme.largeSpacing),

          //Get going
          TranslatedText(
            'home_tab.get_going',
            style: theme.textTheme.headline3,
          ),
          SizedBox(height: theme.defaultSpacing),
          IrmaActionCard(
            titleKey: 'home_tab.action_card.share.title',
            subtitleKey: 'home_tab.action_card.share.subtitle',
            onTap: () => Navigator.of(context).pushNamed(ScannerScreen.routeName),
            icon: IrmaIcons.scanQrcode,
          ),
          SizedBox(height: theme.defaultSpacing),
          IrmaActionCard(
            titleKey: 'home_tab.action_card.fetch.title',
            subtitleKey: 'home_tab.action_card.fetch.subtitle',
            onTap: () =>
                throw UnimplementedError('Credential store not implemented'), // TODO: Implement credential store
            icon: Icons.add_circle_outline,
            invertColors: true,
          ),
          SizedBox(height: theme.largeSpacing),

          //Recent activity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TranslatedText(
                'home_tab.recent_activity',
                style: theme.textTheme.headline4,
              ),
              GestureDetector(
                onTap: () => onChangeTab(IrmaNavBarTab.activity),
                child: TranslatedText('home_tab.view_more', style: theme.hyperlinkTextStyle),
              )
            ],
          ),
          SizedBox(height: theme.defaultSpacing),
          const RecentActivity(),
          SizedBox(height: theme.largeSpacing),

          //More info
          TranslatedText(
            'home_tab.more_information',
            style: theme.textTheme.headline4,
          ),
          SizedBox(height: theme.defaultSpacing),
          const IrmaInfoCard(
            titleKey: 'home_tab.info_card.safety.title',
            bodyKey: 'home_tab.info_card.safety.body',
            avatar: Icon(Icons.shield_outlined, size: 32),
            linkKey: 'home_tab.info_card.safety.link',
          ),
          SizedBox(height: theme.smallSpacing),
          IrmaInfoCard(
            titleKey: 'home_tab.info_card.about.title',
            bodyKey: 'home_tab.info_card.about.body',
            avatar: Image.asset('assets/non-free/irmalogo.png'),
            linkKey: 'home_tab.info_card.about.link',
          )
        ],
      ),
    );
  }
}
