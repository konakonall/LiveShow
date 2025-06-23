//
//  liveshowApp.swift
//  liveshow
//
//  Created by Liam on 2025/6/17.
//

import SwiftUI

@main
struct liveshowApp: App {
    
    @UIApplicationDelegateAdaptor private var delegate: LiveAppDelegate
    
    @StateObject var configCenter: LiveAppConfigCenter
    let server: LiveAppServer
    
    init() {
        let configCenter = LiveAppConfigCenter()
        _configCenter = StateObject(wrappedValue: configCenter)
        server = LiveAppServer(configCenter: configCenter)
    }
    
    var body: some Scene {
        WindowGroup {
            LiveShowView()
                .environmentObject(configCenter)
                .environment(\.server, server)
        }
    }
}
