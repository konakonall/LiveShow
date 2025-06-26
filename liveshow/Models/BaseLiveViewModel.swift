//
//  BaseLiveViewModel.swift
//  liveshow
//
//  Created by Liam on 2025/6/26.
//

import Foundation

extension Task {
    func store(col: inout Array<Task>) {
        col.append(self)
    }
}

@MainActor
class BaseLiveViewModel {
    
    let feed: LiveFeed
    
    internal var service: LiveServiceLocator?
    
    internal var tasks: Array<Task<Void, Error>> = []
    
    init(feed: LiveFeed) {
        self.feed = feed
    }
    
    // FIXME: This is not good practice
    open func inject(service: LiveServiceLocator) {
        self.service = service
    }
    
    func destroy() {
        tasks.forEach { task in
            task.cancel()
        }
        tasks.removeAll()
    }
}
