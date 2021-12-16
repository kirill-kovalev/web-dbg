//
//  ExampleApp.swift
//  Example
//
//  Created by Кирилл on 16.12.2021.
//

import SwiftUI
import WebDBG

let logger = WebServerLogger(port: 8080)

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(server: logger)
        }
    }
}
