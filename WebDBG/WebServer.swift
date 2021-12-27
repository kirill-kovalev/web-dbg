import Foundation
import GCDWebServer

public class WebServerLogger {
    

    var messages: [LogMessage] = []
    
    private lazy var webServer = GCDWebServer()
    
    private let port: UInt
    private lazy var options: [String: Any] = [GCDWebServerOption_Port: port,
                                               GCDWebServerOption_AutomaticallySuspendInBackground: false]

    public init(port: UInt) {
        self.port = port

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackgroundNotification),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForegroundNotification),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
        open()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didEnterBackgroundNotification() {
        if webServer.isRunning {
            webServer.stop()
        }
    }
    
    @objc private func willEnterForegroundNotification() {
        if !webServer.isRunning {
            try? webServer.start(options: options)
        }
    }
    
    public func log(level: LogLevel, message: String) {
        messages.append(LogMessage(level: level, message: sanitazeString(message)))
    }
    
    @discardableResult
    func open() -> Bool {
        
        webServer.addDefaultHandler(
            forMethod: "GET",
            request: GCDWebServerRequest.self) { request-> GCDWebServerResponse? in
                
                return GCDWebServerErrorResponse(statusCode: 405)
        }
        
        webServer.addHandler(
            forMethod: "GET",
            path: "/",
            request: GCDWebServerRequest.self) { [weak self] request -> GCDWebServerResponse? in
                guard let self = self,
                    let path = Bundle(for: type(of: self)).path(forResource: "debuger.html", ofType: nil),
                    let template =  try? String(contentsOfFile: path, encoding: .utf8) else {
                        return GCDWebServerErrorResponse(statusCode: 405)
                }
                                
                return GCDWebServerDataResponse(html: template);
        }
        
        webServer.addHandler(
            forMethod: "GET",
            path: "/log",
            request: GCDWebServerRequest.self) { [weak self] (requst, completion) in

                guard let self = self else {
                        completion(GCDWebServerErrorResponse(statusCode: 405))
                        return
                }
                
                let logs: [LogMessage]
                
                if let skipString = requst.query?["skip"],
                   let skip = Int(skipString) {
                    logs = Array(self.messages.dropFirst(skip))
                } else {
                    logs = self.messages
                }
                
                guard let encodedData = try? JSONEncoder().encode(logs) else {
                    completion(GCDWebServerErrorResponse(statusCode: 405))
                    return
                }
                completion(GCDWebServerDataResponse(data: encodedData, contentType: "application/json"))
        }
        
        try? webServer.start(options: options)
        
        return true;
    }
    

    private func sanitazeString(_ msg: String) -> String {
        var message = msg;
        message = message.replacingOccurrences(of: "&", with: "&amp;")
        message = message.replacingOccurrences(of: "<", with: "&lt;")
        message = message.replacingOccurrences(of: ">", with: "&gt;")
        message = message.replacingOccurrences(of: "\n", with: "<br>")
        while (message.contains("  ") || message.contains("&nbsp ") || message.contains(" &nbsp")) {
            message = message.replacingOccurrences(of: "  ", with: "&nbsp&nbsp")
            message = message.replacingOccurrences(of: "&nbsp ", with: "&nbsp&nbsp")
            message = message.replacingOccurrences(of: " &nbsp", with: "&nbsp&nbsp")
        }
        return message;
    }
    
}
