import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../widgets/irma_repository_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../home/home_screen.dart';
import 'accept_terms/accept_terms_screen.dart';
import 'bloc/enrollment_bloc.dart';
import 'choose_pin/choose_pin_screen.dart';
import 'confirm_pin/confirm_pin_screen.dart';
import 'confirm_pin/widgets/pin_confirmation_failed_dialog.dart';
import 'enrollment_failed_screen.dart';
import 'introduction/introduction_screen.dart';
import 'provide_email/email_sent_screen.dart';
import 'provide_email/provide_email_screen.dart';

class EnrollmentScreen extends StatelessWidget {
  static const routeName = 'enrollment';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EnrollmentBloc(
        language: FlutterI18n.currentLocale(context)!.languageCode,
        repo: IrmaRepositoryProvider.of(context),
      ),
      child: _ProvidedEnrollmentScreen(),
    );
  }
}

class _ProvidedEnrollmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EnrollmentBloc>();
    void addEvent(EnrollmentBlocEvent event) => bloc.add(event);
    void addOnPreviousPressed() => bloc.add(EnrollmentPreviousPressed());
    void addOnNextPressed() => bloc.add(EnrollmentNextPressed());
    final newPin = ValueNotifier('');

    return BlocConsumer<EnrollmentBloc, EnrollmentState>(
      listener: (BuildContext context, EnrollmentState state) {
        //Show dialog when pin confirmation failed
        if (state is EnrollmentConfirmPin && state.confirmationFailed) {
          showDialog(
            context: context,
            builder: (context) => PinConfirmationFailedDialog(),
          );
        }
        //Navigate to home on EnrollmentCompleted
        if (state is EnrollmentCompleted) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      },
      builder: (context, blocState) {
        var state = blocState;
        if (state is EnrollmentIntroduction) {
          return IntroductionScreen(
            currentStepIndex: state.currentStepIndex,
            onContinue: addOnNextPressed,
            onPrevious: addOnPreviousPressed,
          );
        }
        if (state is EnrollmentChoosePin) {
          return ChoosePinScreen(
            onPrevious: addOnPreviousPressed,
            onChoosePin: (pin) => addEvent(
              EnrollmentPinChosen(pin),
            ),
            newPinNotifier: newPin,
          );
        }
        if (state is EnrollmentConfirmPin) {
          return ConfirmPinScreen(
            newPinNotifier: newPin,
            onPrevious: addOnPreviousPressed,
            submitConfirmationPin: (pin) => addEvent(
              EnrollmentPinConfirmed(pin),
            ),
          );
        }
        if (state is EnrollmentProvideEmail) {
          return ProvideEmailScreen(
            email: state.email,
            onPrevious: addOnPreviousPressed,
            onEmailSkipped: () => addEvent(EnrollmentEmailSkipped()),
            onEmailProvided: (email) => addEvent(
              EnrollmentEmailProvided(email),
            ),
          );
        }
        if (state is EnrollmentEmailSent) {
          return EmailSentScreen(
            email: state.email,
            onContinue: addOnNextPressed,
          );
        }
        if (state is EnrollmentAcceptTerms) {
          return AcceptTermsScreen(
            isAccepted: state.isAccepted,
            onPrevious: addOnPreviousPressed,
            onContinue: addOnNextPressed,
            onToggleAccepted: (isAccepted) => addEvent(
              EnrollmentTermsUpdated(
                isAccepted: isAccepted,
              ),
            ),
          );
        }
        if (state is EnrollmentFailed) {
          return EnrollmentFailedScreen(
            onPrevious: addOnPreviousPressed,
            onRetryEnrollment: () => addEvent(EnrollmentRetried()),
          );
        }
        // If state is loading/initial/submitting show centered loading indicator
        return Scaffold(
          body: Center(
            child: LoadingIndicator(),
          ),
        );
      },
    );
  }
}
