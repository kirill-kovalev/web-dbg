//
//  DebugManager.swift
//
//  Created by Кирилл on 11.01.2022.
//

public struct LoggerDestination: OptionSet {
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public let rawValue: Int

    public static let file = LoggerDestination(rawValue: 1 << 0)
    public static let console = LoggerDestination(rawValue: 1 << 1)
    public static let web = LoggerDestination(rawValue: 1 << 2)
}

import SwiftyBeaver
public class DebugManager {
    let port: Int
    
    private var actions: [DebugerAction] = []
    
    public init(destinations: LoggerDestination, port: Int = 0) {
        if destinations.contains(.file) {
            SwiftyBeaver.addDestination(FileDestination())
        }
        
        if destinations.contains(.console) {
            SwiftyBeaver.addDestination(ConsoleDestination())
        }
        
        if destinations.contains(.web) {
            SwiftyBeaver.addDestination(WebLoggerDestination(port: port))
        }
        
        self.port = port
        
        actions = [
            .init(title: "logs", action: { [weak self] controller, _ in
                guard let self = self else { return }
                let vc = DebugSafariController()
                vc.port = self.port
                controller?.present(vc, animated: false, completion: nil)
            })
        ]
    }
    
    public func addAction(_ action: DebugerAction) {
        actions.append(action)
    }
    
    public func log(
        level: SwiftyBeaver.Level = .info,
        message: Any?,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        SwiftyBeaver.custom(level: level, message: message ?? "nil", file: file,
                            function: function, line: line, context: context)
    }
    
    public func presentDebugAlert(from presentingController: UIViewController) {
        let alert = UIAlertController()
        
        actions.map({ action in
            UIAlertAction(title: action.title,
                          style: .default,
                          handler: { [weak presentingController, weak alert] _ in
                            action.action(presentingController, alert)
                          })
        }).forEach(alert.addAction)
        
        presentingController.present(alert, animated: false, completion: nil)
    }
}
