import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/screens/change_pin/widgets/cancel_button.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/irma_button.dart';

class Success extends StatelessWidget {
  static const String routeName = 'change_pin/success';

  final void Function() cancel;

  const Success({@required this.cancel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CancelButton(cancel: cancel),
        title: Text(FlutterI18n.translate(context, 'change_pin.success.title')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: IrmaTheme.of(context).spacing),
            Text('change_pin.success.message'),
            SizedBox(height: IrmaTheme.of(context).spacing),
            IrmaButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              label: 'change_pin.success.continue',
            ),
          ],
        ),
      ),
    );
  }
}