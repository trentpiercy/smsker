//
//  MessagerViewController.swift
//  Runner
//
//  Created by Artur "RoketStorm" Shamsutdinov on 28.08.2020.
//

import UIKit
import MessageUI

class MessagerViewController: UIViewController, MFMessageComposeViewControllerDelegate {    
    let phone: String
    let message: String

    required init?(coder decoder: NSCoder) {
        self.phone = ""
        self.message = ""
        super.init(coder: decoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.phone = ""
        self.message = ""
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(phone: String, message: String) {
        self.phone = phone
        self.message = message
        super.init()
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

}
