//
//  ViewController.swift
//  Example
//
//  Created by Кирилл on 11.01.2022.
//

import UIKit
import WebDBG

class ViewController: UIViewController {
    
    @IBOutlet private weak var textField: UITextView!
    @IBOutlet private weak var sendButton: UIButton!
    
    var debugManager: DebugManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        debugManager = .init(destinations: [.web, .console, .file], port: 8080)

    }
    @IBAction func buttonTap(_ sender: Any) {
        debugManager.log(level: .info, message: textField.text, context: nil)
        textField.text = nil
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        if motion == .motionShake {
            debugManager.presentDebugAlert(from: self)
        }
    }
}
