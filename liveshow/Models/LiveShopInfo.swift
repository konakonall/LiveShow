//
//  LiveShopInfo.swift
//  liveshow
//
//  Created by Liam on 2025/7/3.
//

import Foundation

struct LiveShopInfo {
    let feedId: FeedID
    let itemName: String
    let price: Double
    let cover: String
    
    static func mock(feedId: FeedID) -> LiveShopInfo {
        return LiveShopInfo(feedId: feedId, itemName: "Card", price: 100.99, cover: "")
    }
}
