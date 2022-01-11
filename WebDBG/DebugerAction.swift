//
//  DebuggerAction.swift
//
//  Created by Кирилл on 11.01.2022.
//

import UIKit

public struct DebugerAction {
    public init(title: String, action: @escaping ((UIViewController?, UIAlertController?) -> Void)) {
        self.title = title
        self.action = action
    }
    
    let title: String
    let action: ((UIViewController?, UIAlertController?) -> Void)
}
