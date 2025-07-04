//
//  LiveShopInfo.swift
//  liveshow
//
//  Created by Liam on 2025/7/3.
//

import Foundation

struct LiveShopInfo {
    let feedId: FeedID
    let itemId: UInt64
    let itemName: String
    let price: Double
    let cover: String
    
    static func mock(feedId: FeedID) -> LiveShopInfo {
        return LiveShopInfo(feedId: feedId, itemId: UInt64.random(in: 0...UInt64.max), itemName: "Card", price: 100.99, cover: "")
    }
}
