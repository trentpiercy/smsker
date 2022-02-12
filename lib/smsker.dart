import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Smsker {
  static const MethodChannel _channel = const MethodChannel('smsker');

  /// Send SMS [message] to [phone].
  ///
  /// ```dart
  /// sendSms(phone: "123123123", message: "Hi!");
  /// ```
  static Future<String> sendSms(
      {@required String phone, @required String message}) async {
    // Future<dynamic> Function(MethodCall) handler = (call) {};

    // _channel.setMethodCallHandler(handler);

    final String phoneSent = await _channel
        .invokeMethod('sendSms', {'phone': phone, 'message': message});

    // _channel.setMethodCallHandler(null);

    return phoneSent;
  }

  static void listenSmsResult({@required Function(String) callback}) {
    _channel.setMethodCallHandler((call) {
      // Execute the callback
      callback(call.arguments);
      // Remove the handler
      _channel.setMethodCallHandler(null);
      return;
    });
  }
}
