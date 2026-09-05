// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Farmer Procurement';

  @override
  String get bookSlot => 'Book Slot';

  @override
  String get payments => 'Payments';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get slotStatus => 'Slot Status';

  @override
  String get reschedule => 'Reschedule';

  @override
  String get alerts => 'Alerts';

  @override
  String get totalReceived => 'Total Received';

  @override
  String get inProcessPending => 'In Process / Pending';

  @override
  String get transactionRecords => 'Transaction Records';

  @override
  String get token => 'Token';

  @override
  String get crop => 'Crop';

  @override
  String get quintal => 'Quintal';

  @override
  String get paid => 'PAID';

  @override
  String get pending => 'PENDING';

  @override
  String get processing => 'PROCESSING';

  @override
  String get returnToHome => 'Return to Home';

  @override
  String get initiateDbtPayment => 'Initiate DBT Payment';

  @override
  String get authorizingDbtTransfer => 'Authorizing DBT Transfer...';

  @override
  String get beneficiaryBankDetails => 'Beneficiary Bank Details';

  @override
  String get farmerName => 'Farmer Name';

  @override
  String get bank => 'Bank';

  @override
  String get ifscCode => 'IFSC Code';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get reviewProcurementOffer => 'Review Procurement Offer';

  @override
  String get acceptOffer => 'Accept Offer';

  @override
  String get declineOffer => 'Decline (Return Produce)';

  @override
  String get totalNetPayable => 'Total Net Payable';

  @override
  String get selectActiveBookingReschedule =>
      'Select an active booking to reschedule.';

  @override
  String get activeTab => 'Active';

  @override
  String get historyTab => 'History / Completed';

  @override
  String get noActiveBookings => 'No active bookings found.';

  @override
  String get noBookingHistory => 'No booking history found.';

  @override
  String get centre => 'Centre';

  @override
  String get slotTime => 'Slot Time';

  @override
  String get bookingDate => 'Booking Date';

  @override
  String get trackStatus => 'Track Status';

  @override
  String get noTransactions => 'No transaction records found.';

  @override
  String get transactionId => 'Transaction ID';

  @override
  String get paymentStatus => 'Payment Status';

  @override
  String get dbtTransferred => 'DBT Transferred';

  @override
  String get utrNumber => 'UTR Number';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications right now.';

  @override
  String get allCaughtUp => 'You are all caught up!';

  @override
  String get clearAll => 'Clear All';

  @override
  String get bookSlotTitle => 'Book Procurement Slot';

  @override
  String get stepCropDetails => 'Crop Details';

  @override
  String get stepCenterDate => 'Center & Date';

  @override
  String get stepReview => 'Review & Confirm';

  @override
  String get selectCrop => 'Select Crop';

  @override
  String get cropRequired => 'Please select a crop';

  @override
  String get quantityQuintalLabel => 'Estimated Quantity (Quintals)';

  @override
  String get quantityRequired => 'Please enter quantity';

  @override
  String get quantityPositive => 'Quantity must be greater than 0';

  @override
  String get season => 'Season';

  @override
  String get state => 'State';

  @override
  String get district => 'District';

  @override
  String get procurementCenter => 'Procurement Center';

  @override
  String get selectCenter => 'Select Procurement Center';

  @override
  String get centerRequired => 'Please select a center';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectTimeSlot => 'Select Time Slot';

  @override
  String get timeSlotRequired => 'Please select a time slot';

  @override
  String get morningSlot => 'Morning (09:00 AM - 01:00 PM)';

  @override
  String get afternoonSlot => 'Afternoon (02:00 PM - 05:00 PM)';

  @override
  String get reviewBookingDetails => 'Review Booking Details';

  @override
  String get confirmAndGenerateToken => 'Confirm & Generate Token';

  @override
  String get bookingSuccess => 'Slot Booked Successfully!';

  @override
  String get yourTokenNumber => 'Your Token Number';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String stepProgress(int current, int total, String title) {
    return 'Step $current of $total: $title';
  }

  @override
  String get stepSelectCrop => 'Select Crop';

  @override
  String get stepProduceQuantity => 'Produce Quantity';

  @override
  String get stepLocation => 'Location';

  @override
  String get stepCenter => 'Center';

  @override
  String get stepDateAndSlot => 'Date & Slot';

  @override
  String get continueButton => 'Continue';

  @override
  String get confirmAndBookSlot => 'Confirm & Book Slot';

  @override
  String get duplicateBookingError =>
      'You already have an active booking for this date and time slot.';

  @override
  String get slotFullError =>
      'This time slot is full. Please choose another slot.';

  @override
  String failedToBookSlot(String error) {
    return 'Failed to book slot: $error';
  }

  @override
  String get cropQuestion => 'Which crop are you bringing to sell?';

  @override
  String estimatedQuantityForCrop(String crop) {
    return 'Estimated Quantity for $crop';
  }

  @override
  String get quantitySubtext =>
      'Enter the quantity in quintals as per your land registration record.';

  @override
  String get selectRegion => 'Select Region';

  @override
  String get chooseDateAndArrivalSlot => 'Choose Date & Arrival Slot';

  @override
  String get availableTimeWindows => 'Available Time Windows';

  @override
  String dateLabel(String date) {
    return 'Date: $date';
  }

  @override
  String get signInToViewNotifications => 'Sign in to view notifications.';

  @override
  String unableToLoadNotifications(String error) {
    return 'Unable to load notifications: $error';
  }

  @override
  String get noNotificationsYet => 'No notifications yet.';

  @override
  String get gateVerificationPass => 'Gate Verification Pass';

  @override
  String get showTokenAtGate =>
      'Show this token at the procurement center gate';

  @override
  String get tapCardToViewQr => 'Tap card to view QR Pass';

  @override
  String get cropAndQty => 'Crop & Qty';

  @override
  String get dateAndSlot => 'Date & Slot';

  @override
  String get procurementCentre => 'Procurement Centre';

  @override
  String get completed => 'Completed';

  @override
  String get rejected => 'Rejected';

  @override
  String get noSlotsBookedTillDate => 'No slots booked till date';

  @override
  String dateTimeFormat(int day, int month, int year, String slot) {
    return '$day/$month/$year ($slot)';
  }

  @override
  String shortDateFormat(int day, int month, String slot) {
    return '$day/$month • $slot';
  }

  @override
  String fullDateFormat(String crop, int day, int month, int year) {
    return '$crop • $day/$month/$year';
  }

  @override
  String get dbtPaymentDispatched => 'DBT Payment Dispatched!';

  @override
  String get pfmsRoutingMessage =>
      'Payment order processed and routed through PFMS.';

  @override
  String get amountTransferred => 'Amount Transferred';

  @override
  String get beneficiary => 'Beneficiary';

  @override
  String get paymentMode => 'Payment Mode';

  @override
  String get directBenefitTransfer => 'Direct Benefit Transfer (DBT)';

  @override
  String get transactionUtr => 'Transaction UTR';

  @override
  String get timestamp => 'Timestamp';
}
