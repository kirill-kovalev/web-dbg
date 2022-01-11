//
//  LogMessage.swift
//
//  Created by Кирилл on 11.01.2022.
//

import Foundation

struct LogMessage: Encodable {
    let date = Date().timeIntervalSince1970
    let level: LogLevel
    let message: String
    
    var style: String { level.rawValue }
}
