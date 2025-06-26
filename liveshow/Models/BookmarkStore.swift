//
//  BookmarkStore.swift
//  liveshow
//
//  Created by Liam on 2025/6/25.
//

import Foundation

class BookmarkStore {
    
    private(set) var bookmarkedFeed: Set<UInt64> = []
    
    func bookmark(feedId: FeedID) {
        bookmarkedFeed.insert(feedId)
    }
    
    func unBookmark(feedId: FeedID) {
        bookmarkedFeed.remove(feedId)
    }
    
    func isBookmarked(feedId: FeedID) -> Bool {
        return bookmarkedFeed.contains(feedId)
    }
}
