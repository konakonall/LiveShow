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
    
    @State private var configCenter = LiveAppConfigCenter()
    @State private var appServer = MockLiveAppServer()
    
    init() {
        configCenter.initConfig(server: appServer)
    }
    
    var body: some Scene {
        WindowGroup {
            LiveShowView(feedId: 1)
                .environment(configCenter)
                .environment(\.server, appServer)
                .preferredColorScheme(.dark)
        }
    }
}
