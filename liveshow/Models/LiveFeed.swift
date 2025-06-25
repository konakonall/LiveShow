//
//  LiveFeed.swift
//  liveshow
//
//  Created by Liam on 2025/6/25.
//

import Foundation

typealias FeedID = UInt64

@Observable class LiveFeed {
    let feedId: FeedID
    let title: String
    let playUrl: String
    let anchor: User
    
    var watchingCount: UInt32
    
    init(feedId: FeedID, title: String, watchingCount: UInt32, playUrl: String, anchor: User) {
        self.feedId = feedId
        self.title = title
        self.watchingCount = watchingCount
        self.playUrl = playUrl
        self.anchor = anchor
    }
    
    static func mock() -> LiveFeed {
        let anchor = User(userId: 1, userName: "Liam", userAvatar: nil)
        return LiveFeed(feedId: 1, title: "Welcome to My Live", watchingCount: 100, playUrl: "", anchor: anchor)
    }
}
