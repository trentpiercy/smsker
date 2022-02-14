//
//  MessagerViewController.swift
//  Runner
//
//  Created by Artur "RoketStorm" Shamsutdinov on 28.08.2020.
//

import UIKit
import MessageUI
import Flutter

class MessagerViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    var phone = ""
    var message = ""

    func setPhoneAndMessage(phone: String, message: String) {
        self.phone = phone
        self.message = message
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let messageVC = MFMessageComposeViewController()
        messageVC.body = self.message
        messageVC.recipients = [self.phone]
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: true, completion: nil)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            self.onComplete(result: "cancelled")
        case .failed:
            self.onComplete(result: "failed")
        case .sent:
            self.onComplete(result: "sent")
        default:
            return
        }
        self.dismiss(animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    func onComplete(result: String) {
        let rootViewController : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "smsker", binaryMessenger: rootViewController.binaryMessenger)
        methodChannel.invokeMethod("messageComposeResult", arguments: result)
    }
}
