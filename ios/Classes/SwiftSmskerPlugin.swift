import Flutter
import UIKit
import MessageUI

public class SwiftSmskerPlugin: NSObject, FlutterPlugin, UINavigationControllerDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "smsker", binaryMessenger: registrar.messenger())
    let instance = SwiftSmskerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "sendSms") {
      let args = call.arguments as! Dictionary<String, Any>
      let phone = args["phone"] as! String
      let message = args["message"] as! String

      let messagerView = MessagerViewController()
      messagerView.setPhoneAndMessage(phone: phone, message: message)
      
      if MFMessageComposeViewController.canSendText() {
          UIApplication.shared.keyWindow?.rootViewController?.present(messagerView, animated: true, completion: nil)
      }
      // print("sendSms call returning")
      result(100500)
    } else {
      result (200500)
    }
  }
}
