//
//  MessagerViewController.swift
//  Runner
//
//  Created by Artur "RoketStorm" Shamsutdinov on 28.08.2020.
//
//  https://www.twilio.com/blog/2018/07/sending-text-messages-from-your-ios-app-in-swift-using-mfmessagecomposeviewcontroller.html
// 

import UIKit
import MessageUI

class MessagerViewController: UIViewController, MFMessageComposeViewControllerDelegate {    
    let phone: String
    let message: String
    
    init(phone: String, message: String) {
        self.phone = phone
        self.message = message
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
        case .failed:
            print("Message failed")
        case .sent:
            print("Message was sent")
        default:
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = [phone]
        composeVC.body = message
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
    }
}

}
