//
//  LiveAppServer.swift
//  liveshow
//
//  Created by Liam on 2025/6/23.
//

import Foundation

class LiveAppServer: ObservableObject {
    private let configCenter: LiveAppConfigCenter
    private var timer: Timer?
    
    init(configCenter: LiveAppConfigCenter) {
        self.configCenter = configCenter
        
        fetchConfig()
    }
    
    func fetchConfig() {
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.configCenter.helloMessage = "hello Live"
            self.timer = nil
        }
        
        self.timer = timer
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
