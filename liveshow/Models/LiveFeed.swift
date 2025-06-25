//
//  LiveFeed.swift
//  liveshow
//
//  Created by Liam on 2025/6/25.
//

import Foundation

typealias FeedID = UInt64

struct LiveFeed {
    let feedId: FeedID
    let title: String
    let watchingCount: UInt32
    let playUrl: String
    let anchor: User
    
    static func mock() -> LiveFeed {
        let anchor = User(userId: 1, userName: "Liam", userAvatar: nil)
        return LiveFeed(feedId: 1, title: "Welcome to My Live", watchingCount: 100, playUrl: "", anchor: anchor)
    }
}
