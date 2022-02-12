import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum SmskerResult {
  /// Message view failed to open or failed to send
  Failed,

  /// Message view opened but not sent
  Cancelled,

  /// Message sent
  Sent
}

class Smsker {
  static const MethodChannel _channel = const MethodChannel('smsker');

  /// Send SMS [message] to [phone].
  ///
  /// ```dart
  /// sendSms(phone: "123123123", message: "Hi!");
  /// ```
  static Future<SmskerResult> sendSms(
      {@required String phone, @required String message}) async {
    if (Platform.isIOS) {
      BehaviorSubject<SmskerResult> resultStream = BehaviorSubject();

      // Handle iOS message compose result
      Future<void> callHandler(MethodCall call) async {
        if (call.method == 'messageComposeResult') {
          switch (call.arguments) {
            case 'sent':
              resultStream.add(SmskerResult.Sent);
              return;
            case 'cancelled':
              resultStream.add(SmskerResult.Cancelled);
              return;
            default:
          }
        }

        // Fail if not sent or cancelled
        resultStream.add(SmskerResult.Failed);
      }

      // Call handler for message view completion
      _channel.setMethodCallHandler(callHandler);

      // Bring up the message view
      await _channel
          .invokeMethod('sendSms', {'phone': phone, 'message': message});

      // Wait for user to finish either sending or cancelling
      final result = await resultStream.first;

      // Remove the handler and return
      _channel.setMethodCallHandler(null);
      resultStream.close();
      return result;
    } else if (Platform.isAndroid) {
      // Send in background on Android
      final result = await _channel
          .invokeMethod('sendSms', {'phone': phone, 'message': message});

      if (result == 'success') {
        return SmskerResult.Sent;
      }
    }

    return SmskerResult.Failed;
  }
}
