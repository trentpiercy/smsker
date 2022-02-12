import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum SmskerResult { Failed, Cancelled, Sent }

class Smsker {
  static const MethodChannel _channel = const MethodChannel('smsker');

  /// Send SMS [message] to [phone].
  ///
  /// ```dart
  /// sendSms(phone: "123123123", message: "Hi!");
  /// ```
  static Future<SmskerResult> sendSms(
      {@required String phone, @required String message}) async {
    BehaviorSubject<SmskerResult> resultStream = BehaviorSubject();

    Future<void> handler(MethodCall call) async {
      if (call.method == 'completed') {
        switch (call.arguments) {
          case 'cancelled':
            resultStream.add(SmskerResult.Cancelled);
            return;
          case 'sent':
            resultStream.add(SmskerResult.Sent);
            return;
          default:
            resultStream.add(SmskerResult.Failed);
        }
      }
    }

    _channel.setMethodCallHandler(handler);

    await _channel
        .invokeMethod('sendSms', {'phone': phone, 'message': message});

    final result = await resultStream.first;
    _channel.setMethodCallHandler(null);
    resultStream.close();

    return result;
  }

  // static void listenSmsResult({@required Function(String) callback}) {
  //   _channel.setMethodCallHandler((call) {
  //     // Execute the callback
  //     callback(call.arguments);
  //     // Remove the handler
  //     _channel.setMethodCallHandler(null);
  //     return;
  //   });
  // }
}
