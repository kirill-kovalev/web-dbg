//
//  File.swift
//  WebDBG
//
//  Created by Кирилл on 15.12.2021.
//

import Foundation

public enum LogLevel: String, Encodable {
    case verbose
    case debug
    case info
    case warning
    case error
    
}

struct LogMessage: Encodable {
    let date = Date().timeIntervalSince1970
    let level: LogLevel
    let message: String
    
    var style: String { level.rawValue }
}
