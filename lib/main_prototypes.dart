// This code is not null safe yet.
// @dart=2.11

import 'package:flutter/material.dart';
import 'package:irmamobile/app.dart';
import 'package:irmamobile/src/data/irma_mock_bridge.dart';
import 'package:irmamobile/src/data/irma_preferences.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/prototypes/prototypes_screen.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/irma_repository_provider.dart';

Future<void> main() async {
  final repository = IrmaRepository(
    client: IrmaMockBridge(),
    preferences: await IrmaPreferences.fromInstance(),
  );

  runApp(PrototypesApp(repository: repository));
}

class PrototypesApp extends StatelessWidget {
  final Map<String, WidgetBuilder> routes = {
    PrototypesScreen.routeName: (BuildContext context) => PrototypesScreen(),
  };

  final IrmaRepository repository;

  PrototypesApp({this.repository});

  @override
  Widget build(BuildContext context) => IrmaRepositoryProvider(
        repository: repository,
        child: IrmaTheme(
          builder: (context) {
            return MaterialApp(
              key: const Key('app'),
              title: 'IRMA',
              theme: IrmaTheme.of(context).themeData,
              localizationsDelegates: AppState.defaultLocalizationsDelegates(),
              supportedLocales: AppState.defaultSupportedLocales(),
              locale: const Locale('zh', 'Hant'),
              initialRoute: PrototypesScreen.routeName,
              routes: routes,
            );
          },
        ),
      );
}
