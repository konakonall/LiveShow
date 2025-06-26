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
    
    @State private var serviceLocator = LiveServiceLocator()
    
    init() {
        serviceLocator.configCenter.initConfig(server: serviceLocator.server)
    }
    
    var body: some Scene {
        WindowGroup {
            LiveShowView(feedId: 1)
                .environment(serviceLocator)
                .preferredColorScheme(.dark)
        }
    }
}
