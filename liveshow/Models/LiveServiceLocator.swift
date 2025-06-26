//
//  LiveServiceLocator.swift
//  liveshow
//
//  Created by Liam on 2025/6/26.
//

import Foundation

@Observable class LiveServiceLocator {
    
    private let bookmarkStore: BookmarkStore
    let server: LiveAppServerProtocol
    let configCenter: LiveAppConfigCenter
    
    init() {
        self.bookmarkStore = BookmarkStore()
        self.server = MockLiveAppServer(bookmarkMgr: self.bookmarkStore)
        self.configCenter = LiveAppConfigCenter()
    }
    
    init(bookmarkStore: BookmarkStore,
         server: LiveAppServerProtocol,
         configCenter: LiveAppConfigCenter) {
        self.bookmarkStore = bookmarkStore
        self.server = server
        self.configCenter = configCenter
    }
}
