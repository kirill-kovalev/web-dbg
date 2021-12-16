//
//  ContentView.swift
//  Example
//
//  Created by Кирилл on 16.12.2021.
//

import SwiftUI
import WebDBG

struct ContentView: View {
    let server: WebServerLogger
    
    @State var textFieldText = ""
    
    var body: some View {
        VStack {
            TextField("message", text: $textFieldText).padding()
            Button("Send", action: {
                self.server.log(level: .info, message: textFieldText)
                textFieldText = ""
            }).padding()
        }.padding()
    }
}
