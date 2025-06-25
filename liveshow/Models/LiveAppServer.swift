//
//  LiveAppServer.swift
//  liveshow
//
//  Created by Liam on 2025/6/23.
//

import Foundation

protocol LiveAppServerProtocol {
    func fetchConfig() async throws -> AppGlobalConfig
    
    func fetchFeedInfo(feedId: FeedID) async throws -> LiveFeed
}

extension LiveAppServerProtocol {
    func fetchConfig() async throws -> AppGlobalConfig {
        throw CancellationError()
    }
    
    func fetchFeedInfo(feedId: FeedID) async throws -> LiveFeed {
        throw CancellationError()
    }
}

struct MockLiveAppServer: LiveAppServerProtocol {
    private let NETWORK_SLEEP_SECS = 1
    
    func fetchConfig() async throws -> AppGlobalConfig {
        try await sleep()
        return AppGlobalConfig(hello: "Hello User", locale: "ZH")
    }
    
    func fetchFeedInfo(feedId: FeedID) async throws -> LiveFeed {
        try await sleep()
        return LiveFeed.mock()
    }
    
    private func sleep() async throws {
        try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * NETWORK_SLEEP_SECS))
    }
}

struct RealLiveAppServer: LiveAppServerProtocol {
}
