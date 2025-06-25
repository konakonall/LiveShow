//
//  LiveAppConfigCenter.swift
//  liveshow
//
//  Created by Liam on 2025/6/23.
//

import Foundation

@Observable class LiveAppConfigCenter {
    
    private(set) var helloMessage: String?
    
    func initConfig(server: LiveAppServerProtocol) {
        Task {
            do {
                let config = try await server.fetchConfig()
                helloMessage = config.hello
            } catch {
                print(error)
            }
        }
    }
}
