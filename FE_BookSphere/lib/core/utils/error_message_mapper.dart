import 'package:booksphere_app/core/constants/app_message_keys.dart';
import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:flutter/widgets.dart';

class ErrorMessageMapper {
  const ErrorMessageMapper._();

  static String mapCode(BuildContext context, String? code, {int? statusCode}) {
    final l10n = context.l10n;

    if (statusCode == 401) {
      return l10n.invalidCredentials;
    }
    if (statusCode == 500 || statusCode == 503) {
      return l10n.serverUnavailable;
    }

    return switch (code) {
      AppMessageKeys.authInvalidCredentials => l10n.invalidCredentials,
      AppMessageKeys.authAccountInactive => l10n.accountInactive,
      AppMessageKeys.authUsernameDuplicated ||
      AppMessageKeys.usernameAlreadyExists => l10n.usernameDuplicated,
      AppMessageKeys.authEmailDuplicated ||
      AppMessageKeys.emailAlreadyExists => l10n.emailDuplicated,
      AppMessageKeys.logoutFailed => l10n.logoutFailedButCleared,
      AppMessageKeys.networkError => l10n.networkError,
      AppMessageKeys.serverUnavailable ||
      AppMessageKeys.authLoginInvalidResponse ||
      AppMessageKeys.authRegisterInvalidResponse => l10n.serverUnavailable,
      AppMessageKeys.invalidRegistrationData => l10n.invalidRegistrationData,
      AppMessageKeys.registrationConflict => l10n.registrationConflict,
      AppMessageKeys.bookOutOfStock => l10n.bookOutOfStock,
      AppMessageKeys.bookInactive => l10n.bookInactive,
      AppMessageKeys.borrowSagaFailed => l10n.borrowSagaFailed,
      AppMessageKeys.borrowAlreadyReturned => l10n.borrowAlreadyReturned,
      AppMessageKeys.borrowNotFound => l10n.borrowNotFound,
      AppMessageKeys.borrowNotAllowed => l10n.borrowNotAllowed,
      AppMessageKeys.unknownError => l10n.unknownError,
      _ => l10n.unknownError,
    };
  }
}
