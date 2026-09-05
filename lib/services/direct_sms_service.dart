import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectSmsService {
  /// Opens the device's default SMS app with recipient and message pre-filled
  static Future<bool> sendSilentSms({
    required String recipientPhone,
    required String messageText,
  }) async {
    try {
      final cleanRecipient = recipientPhone.replaceAll(RegExp(r'[\s\-]'), '');
      
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: cleanRecipient,
        queryParameters: <String, String>{
          'body': messageText,
        },
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
        return true;
      } else {
        debugPrint('Could not launch SMS app.');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching SMS: $e');
      return false;
    }
  }

  static Future<bool> sendSlotConfirmation({
    required String phone,
    required String token,
    required String crop,
    required double quantity,
    required String date,
    required String timeSlot,
  }) async {
    final message =
        'KisanSetu: Your slot for $crop (${quantity.toStringAsFixed(1)} Qtl) is confirmed. '
        'Token: $token. Date: $date ($timeSlot). Please carry your QR pass.';

    return sendSilentSms(recipientPhone: phone, messageText: message);
  }

  static Future<bool> sendPaymentConfirmation({
    required String phone,
    required String token,
    required double amount,
    required String utr,
  }) async {
    final message =
        'KisanSetu: Payment of Rs. ${amount.toStringAsFixed(2)} for Token $token '
        'has been credited via DBT. Reference: $utr.';

    return sendSilentSms(recipientPhone: phone, messageText: message);
  }
}