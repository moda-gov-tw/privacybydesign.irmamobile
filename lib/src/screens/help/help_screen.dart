import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/models/irma_configuration.dart';
import 'package:irmamobile/src/screens/issuance_webview/issuance_webview_screen.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/irma_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'help_items.dart';

class HelpScreen extends StatefulWidget {
  static const String routeName = '/help';
  static Key myKey = const Key(routeName);

  final CredentialType credentialType;

  HelpScreen({this.credentialType}) : super(key: myKey);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _scrollviewKey = GlobalKey();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          FlutterI18n.translate(
            context,
            'help.title',
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: _controller,
              key: _scrollviewKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: IrmaTheme.of(context).smallSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: IrmaTheme.of(context).defaultSpacing),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: IrmaTheme.of(context).smallSpacing),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              child: Text(
                                FlutterI18n.translate(context, 'help.faq'),
                                style: Theme.of(context).textTheme.display2,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: IrmaTheme.of(context).smallSpacing),
                          Text(
                            FlutterI18n.translate(context, 'help.faq_info'),
                            style: Theme.of(context).textTheme.body1,
                          ),
                          SizedBox(height: IrmaTheme.of(context).tinySpacing),
                        ],
                      ),
                    ),
                    SizedBox(height: IrmaTheme.of(context).defaultSpacing),
                    HelpItems(
                      credentialType: widget.credentialType,
                      parentKey: _scrollviewKey,
                      parentScrollController: _controller,
                    ),
                    SizedBox(height: IrmaTheme.of(context).defaultSpacing),
                    GestureDetector(
                      onTap: () {
                        try {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return IssuanceWebviewScreen(FlutterI18n.translate(context, 'help.more_link'));
                            }),
                          );
                        } on PlatformException catch (e) {
                          debugPrint(e.toString());
                          debugPrint("error on launch of url - probably bad certificate?");
                        }
                      },
                      child: Center(
                        child: Text(
                          FlutterI18n.translate(context, 'help.more'),
                          style: IrmaTheme.of(context).hyperlinkTextStyle.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: IrmaTheme.of(context).largeSpacing),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: IrmaTheme.of(context).smallSpacing),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              child: Text(
                                FlutterI18n.translate(context, 'help.ask'),
                                style: Theme.of(context).textTheme.display2,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: IrmaTheme.of(context).smallSpacing),
                          Text(
                            FlutterI18n.translate(context, 'help.send'),
                            style: Theme.of(context).textTheme.body1,
                          ),
                          SizedBox(height: IrmaTheme.of(context).smallSpacing),
                          GestureDetector(
                            onTap: () {
                              final String address = FlutterI18n.translate(context, 'help.contact');
                              final String subject = FlutterI18n.translate(context, 'help.mail_subject');
                              launch("mailto:$address?subject=$subject");
                            },
                            child: Center(
                              child: Text(
                                FlutterI18n.translate(context, 'help.email'),
                                style: IrmaTheme.of(context).hyperlinkTextStyle.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: IrmaTheme.of(context).defaultSpacing),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: IrmaTheme.of(context).backgroundBlue,
                border: Border(
                  top: BorderSide(
                    color: IrmaTheme.of(context).primaryLight,
                    width: 2.0,
                  ),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  vertical: IrmaTheme.of(context).defaultSpacing * 1.5, horizontal: IrmaTheme.of(context).largeSpacing),
              child: IrmaButton(
                label: 'help.back_button',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}