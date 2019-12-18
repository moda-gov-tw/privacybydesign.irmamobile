import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/screens/about/about_screen.dart';
import 'package:irmamobile/src/screens/add_cards/card_store_screen.dart';
import 'package:irmamobile/src/screens/history/history_screen.dart';
import 'package:irmamobile/src/screens/settings/settings_screen.dart';
import 'package:irmamobile/src/theme/irma_icons.dart';
import 'package:irmamobile/src/theme/theme.dart';

class WalletDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Container(
        color: IrmaTheme.of(context).primaryLight,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 90.0,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.0, color: Colors.white),
                        color: IrmaTheme.of(context).grayscale85,
                      ),
                      padding: EdgeInsets.only(
                        left: IrmaTheme.of(context).mediumSpacing,
                        right: IrmaTheme.of(context).defaultSpacing,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox.fromSize(
                            size: const Size(40.0, 40.0),
                            child: SvgPicture.asset(
                              'assets/non-free/irma_logo.svg',
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topLeft,
                            ),
                          ),
                          IconButton(
                            iconSize: 18.0,
                            icon: Icon(IrmaIcons.close),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  ),
                  _createDrawerItem(
                    context,
                    icon: IrmaIcons.add,
                    text: FlutterI18n.translate(context, 'drawer.add_cards'),
                    onTap: () => Navigator.pushNamed(context, CardStoreScreen.routeName),
                  ),
                  _createDrawerItem(
                    context,
                    icon: IrmaIcons.time,
                    text: FlutterI18n.translate(context, 'drawer.history'),
                    onTap: () => Navigator.pushNamed(context, HistoryScreen.routeName),
                  ),
                  _createDrawerItem(
                    context,
                    icon: IrmaIcons.settings,
                    text: FlutterI18n.translate(context, 'drawer.settings'),
                    onTap: () => Navigator.pushNamed(context, SettingsScreen.routeName),
                  ),
                  _createDrawerItem(
                    context,
                    icon: IrmaIcons.question,
                    text: FlutterI18n.translate(context, 'drawer.help'),
                    onTap: () => {
                      // TODO: navigate to correct route
                    },
                  ),
                  _createDrawerItem(
                    context,
                    icon: IrmaIcons.info,
                    text: FlutterI18n.translate(context, 'drawer.about'),
                    onTap: () => Navigator.pushNamed(context, AboutScreen.routeName),
                  ),
                ],
              ),
            ),
            // This container holds the align
            Container(
              // This align moves the children to the bottom
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                // This container holds all the children that will be aligned
                // on the bottom and should not scroll with the above ListView
                child: Container(
                  color: IrmaTheme.of(context).primaryBlue,
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: IrmaTheme.of(context).mediumSpacing),
                    title: Text(
                      FlutterI18n.translate(context, 'drawer.lock_wallet'),
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    leading: Icon(IrmaIcons.lock, color: Colors.white),
                    onTap: () {
                      IrmaRepository.get().lock();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(BuildContext context, {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: IrmaTheme.of(context).spacing * 1.5),
      title: Text(
        text,
        style: IrmaTheme.of(context).textTheme.body1,
      ),
      leading: Icon(icon, color: IrmaTheme.of(context).primaryDark),
      onTap: onTap,
    );
  }
}