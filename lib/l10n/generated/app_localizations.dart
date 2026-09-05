import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Farmer Procurement'**
  String get appTitle;

  /// No description provided for @bookSlot.
  ///
  /// In en, this message translates to:
  /// **'Book Slot'**
  String get bookSlot;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @slotStatus.
  ///
  /// In en, this message translates to:
  /// **'Slot Status'**
  String get slotStatus;

  /// No description provided for @reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @totalReceived.
  ///
  /// In en, this message translates to:
  /// **'Total Received'**
  String get totalReceived;

  /// No description provided for @inProcessPending.
  ///
  /// In en, this message translates to:
  /// **'In Process / Pending'**
  String get inProcessPending;

  /// No description provided for @transactionRecords.
  ///
  /// In en, this message translates to:
  /// **'Transaction Records'**
  String get transactionRecords;

  /// No description provided for @token.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get token;

  /// No description provided for @crop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// No description provided for @quintal.
  ///
  /// In en, this message translates to:
  /// **'Quintal'**
  String get quintal;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get paid;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get pending;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'PROCESSING'**
  String get processing;

  /// No description provided for @returnToHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get returnToHome;

  /// No description provided for @initiateDbtPayment.
  ///
  /// In en, this message translates to:
  /// **'Initiate DBT Payment'**
  String get initiateDbtPayment;

  /// No description provided for @authorizingDbtTransfer.
  ///
  /// In en, this message translates to:
  /// **'Authorizing DBT Transfer...'**
  String get authorizingDbtTransfer;

  /// No description provided for @beneficiaryBankDetails.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary Bank Details'**
  String get beneficiaryBankDetails;

  /// No description provided for @farmerName.
  ///
  /// In en, this message translates to:
  /// **'Farmer Name'**
  String get farmerName;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @ifscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifscCode;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @reviewProcurementOffer.
  ///
  /// In en, this message translates to:
  /// **'Review Procurement Offer'**
  String get reviewProcurementOffer;

  /// No description provided for @acceptOffer.
  ///
  /// In en, this message translates to:
  /// **'Accept Offer'**
  String get acceptOffer;

  /// No description provided for @declineOffer.
  ///
  /// In en, this message translates to:
  /// **'Decline (Return Produce)'**
  String get declineOffer;

  /// No description provided for @totalNetPayable.
  ///
  /// In en, this message translates to:
  /// **'Total Net Payable'**
  String get totalNetPayable;

  /// No description provided for @selectActiveBookingReschedule.
  ///
  /// In en, this message translates to:
  /// **'Select an active booking to reschedule.'**
  String get selectActiveBookingReschedule;

  /// No description provided for @activeTab.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeTab;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History / Completed'**
  String get historyTab;

  /// No description provided for @noActiveBookings.
  ///
  /// In en, this message translates to:
  /// **'No active bookings found.'**
  String get noActiveBookings;

  /// No description provided for @noBookingHistory.
  ///
  /// In en, this message translates to:
  /// **'No booking history found.'**
  String get noBookingHistory;

  /// No description provided for @centre.
  ///
  /// In en, this message translates to:
  /// **'Centre'**
  String get centre;

  /// No description provided for @slotTime.
  ///
  /// In en, this message translates to:
  /// **'Slot Time'**
  String get slotTime;

  /// No description provided for @bookingDate.
  ///
  /// In en, this message translates to:
  /// **'Booking Date'**
  String get bookingDate;

  /// No description provided for @trackStatus.
  ///
  /// In en, this message translates to:
  /// **'Track Status'**
  String get trackStatus;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transaction records found.'**
  String get noTransactions;

  /// No description provided for @transactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @dbtTransferred.
  ///
  /// In en, this message translates to:
  /// **'DBT Transferred'**
  String get dbtTransferred;

  /// No description provided for @utrNumber.
  ///
  /// In en, this message translates to:
  /// **'UTR Number'**
  String get utrNumber;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications right now.'**
  String get noNotifications;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up!'**
  String get allCaughtUp;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @bookSlotTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Procurement Slot'**
  String get bookSlotTitle;

  /// No description provided for @stepCropDetails.
  ///
  /// In en, this message translates to:
  /// **'Crop Details'**
  String get stepCropDetails;

  /// No description provided for @stepCenterDate.
  ///
  /// In en, this message translates to:
  /// **'Center & Date'**
  String get stepCenterDate;

  /// No description provided for @stepReview.
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get stepReview;

  /// No description provided for @selectCrop.
  ///
  /// In en, this message translates to:
  /// **'Select Crop'**
  String get selectCrop;

  /// No description provided for @cropRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a crop'**
  String get cropRequired;

  /// No description provided for @quantityQuintalLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Quantity (Quintals)'**
  String get quantityQuintalLabel;

  /// No description provided for @quantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter quantity'**
  String get quantityRequired;

  /// No description provided for @quantityPositive.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than 0'**
  String get quantityPositive;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @procurementCenter.
  ///
  /// In en, this message translates to:
  /// **'Procurement Center'**
  String get procurementCenter;

  /// No description provided for @selectCenter.
  ///
  /// In en, this message translates to:
  /// **'Select Procurement Center'**
  String get selectCenter;

  /// No description provided for @centerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a center'**
  String get centerRequired;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Select Time Slot'**
  String get selectTimeSlot;

  /// No description provided for @timeSlotRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a time slot'**
  String get timeSlotRequired;

  /// No description provided for @morningSlot.
  ///
  /// In en, this message translates to:
  /// **'Morning (09:00 AM - 01:00 PM)'**
  String get morningSlot;

  /// No description provided for @afternoonSlot.
  ///
  /// In en, this message translates to:
  /// **'Afternoon (02:00 PM - 05:00 PM)'**
  String get afternoonSlot;

  /// No description provided for @reviewBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Review Booking Details'**
  String get reviewBookingDetails;

  /// No description provided for @confirmAndGenerateToken.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Generate Token'**
  String get confirmAndGenerateToken;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Slot Booked Successfully!'**
  String get bookingSuccess;

  /// No description provided for @yourTokenNumber.
  ///
  /// In en, this message translates to:
  /// **'Your Token Number'**
  String get yourTokenNumber;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}: {title}'**
  String stepProgress(int current, int total, String title);

  /// No description provided for @stepSelectCrop.
  ///
  /// In en, this message translates to:
  /// **'Select Crop'**
  String get stepSelectCrop;

  /// No description provided for @stepProduceQuantity.
  ///
  /// In en, this message translates to:
  /// **'Produce Quantity'**
  String get stepProduceQuantity;

  /// No description provided for @stepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get stepLocation;

  /// No description provided for @stepCenter.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get stepCenter;

  /// No description provided for @stepDateAndSlot.
  ///
  /// In en, this message translates to:
  /// **'Date & Slot'**
  String get stepDateAndSlot;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @confirmAndBookSlot.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Book Slot'**
  String get confirmAndBookSlot;

  /// No description provided for @duplicateBookingError.
  ///
  /// In en, this message translates to:
  /// **'You already have an active booking for this date and time slot.'**
  String get duplicateBookingError;

  /// No description provided for @slotFullError.
  ///
  /// In en, this message translates to:
  /// **'This time slot is full. Please choose another slot.'**
  String get slotFullError;

  /// No description provided for @failedToBookSlot.
  ///
  /// In en, this message translates to:
  /// **'Failed to book slot: {error}'**
  String failedToBookSlot(String error);

  /// No description provided for @cropQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which crop are you bringing to sell?'**
  String get cropQuestion;

  /// No description provided for @estimatedQuantityForCrop.
  ///
  /// In en, this message translates to:
  /// **'Estimated Quantity for {crop}'**
  String estimatedQuantityForCrop(String crop);

  /// No description provided for @quantitySubtext.
  ///
  /// In en, this message translates to:
  /// **'Enter the quantity in quintals as per your land registration record.'**
  String get quantitySubtext;

  /// No description provided for @selectRegion.
  ///
  /// In en, this message translates to:
  /// **'Select Region'**
  String get selectRegion;

  /// No description provided for @chooseDateAndArrivalSlot.
  ///
  /// In en, this message translates to:
  /// **'Choose Date & Arrival Slot'**
  String get chooseDateAndArrivalSlot;

  /// No description provided for @availableTimeWindows.
  ///
  /// In en, this message translates to:
  /// **'Available Time Windows'**
  String get availableTimeWindows;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateLabel(String date);

  /// No description provided for @signInToViewNotifications.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view notifications.'**
  String get signInToViewNotifications;

  /// No description provided for @unableToLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unable to load notifications: {error}'**
  String unableToLoadNotifications(String error);

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get noNotificationsYet;

  /// No description provided for @gateVerificationPass.
  ///
  /// In en, this message translates to:
  /// **'Gate Verification Pass'**
  String get gateVerificationPass;

  /// No description provided for @showTokenAtGate.
  ///
  /// In en, this message translates to:
  /// **'Show this token at the procurement center gate'**
  String get showTokenAtGate;

  /// No description provided for @tapCardToViewQr.
  ///
  /// In en, this message translates to:
  /// **'Tap card to view QR Pass'**
  String get tapCardToViewQr;

  /// No description provided for @cropAndQty.
  ///
  /// In en, this message translates to:
  /// **'Crop & Qty'**
  String get cropAndQty;

  /// No description provided for @dateAndSlot.
  ///
  /// In en, this message translates to:
  /// **'Date & Slot'**
  String get dateAndSlot;

  /// No description provided for @procurementCentre.
  ///
  /// In en, this message translates to:
  /// **'Procurement Centre'**
  String get procurementCentre;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @noSlotsBookedTillDate.
  ///
  /// In en, this message translates to:
  /// **'No slots booked till date'**
  String get noSlotsBookedTillDate;

  /// No description provided for @dateTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'{day}/{month}/{year} ({slot})'**
  String dateTimeFormat(int day, int month, int year, String slot);

  /// No description provided for @shortDateFormat.
  ///
  /// In en, this message translates to:
  /// **'{day}/{month} • {slot}'**
  String shortDateFormat(int day, int month, String slot);

  /// No description provided for @fullDateFormat.
  ///
  /// In en, this message translates to:
  /// **'{crop} • {day}/{month}/{year}'**
  String fullDateFormat(String crop, int day, int month, int year);

  /// No description provided for @dbtPaymentDispatched.
  ///
  /// In en, this message translates to:
  /// **'DBT Payment Dispatched!'**
  String get dbtPaymentDispatched;

  /// No description provided for @pfmsRoutingMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment order processed and routed through PFMS.'**
  String get pfmsRoutingMessage;

  /// No description provided for @amountTransferred.
  ///
  /// In en, this message translates to:
  /// **'Amount Transferred'**
  String get amountTransferred;

  /// No description provided for @beneficiary.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary'**
  String get beneficiary;

  /// No description provided for @paymentMode.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get paymentMode;

  /// No description provided for @directBenefitTransfer.
  ///
  /// In en, this message translates to:
  /// **'Direct Benefit Transfer (DBT)'**
  String get directBenefitTransfer;

  /// No description provided for @transactionUtr.
  ///
  /// In en, this message translates to:
  /// **'Transaction UTR'**
  String get transactionUtr;

  /// No description provided for @timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get timestamp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
