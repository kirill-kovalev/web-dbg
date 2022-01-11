//
//  WebLoggerDestination.swift
//
//  Created by Кирилл on 11.01.2022.
//

import SwiftyBeaver
import WebDBG
import GCDWebServer

class WebLoggerDestination: BaseDestination {
    
    private let server: WebServerLogger
    
    init(port: Int) {
        GCDWebServer.setLogLevel(4)
        server = WebServerLogger(port: UInt(port))
    }
    
    override func send(
        _ level: SwiftyBeaver.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: Int,
        context: Any? = nil) -> String? {
        server.log(level: level.webServerLevel, message: msg)
        return super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)
    }
}

extension SwiftyBeaver.Level {
    var webServerLevel: LogLevel {
        switch self {
        case .verbose:
            return .verbose
        case .debug:
            return .debug
        case .info:
            return .info
        case .warning:
            return .warning
        case .error:
            return .error
        }
    }
}
