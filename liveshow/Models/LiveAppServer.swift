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
    
    func listenForWatchingCountUpdate(feedId: FeedID) -> AsyncStream<UInt32>
}

extension LiveAppServerProtocol {
    func fetchConfig() async throws -> AppGlobalConfig {
        throw CancellationError()
    }
    
    func fetchFeedInfo(feedId: FeedID) async throws -> LiveFeed {
        throw CancellationError()
    }
    
    func listenForWatchingCountUpdate(feedId: FeedID) -> AsyncStream<UInt32> {
        return AsyncStream { _ in
            
        }
    }
}

struct MockLiveAppServer: LiveAppServerProtocol {
    private let NETWORK_SLEEP_SECS = 0.5
    
    func fetchConfig() async throws -> AppGlobalConfig {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + NETWORK_SLEEP_SECS) {
                continuation.resume(returning: AppGlobalConfig(hello: "Hello User", locale: "ZH"))
            }
        }
    }
    
    func fetchFeedInfo(feedId: FeedID) async throws -> LiveFeed {
        try await sleep()
        return LiveFeed.mock()
    }
    
    func listenForWatchingCountUpdate(feedId: FeedID) -> AsyncStream<UInt32> {
        return AsyncStream { continuation in
            
        }
    }
    
    private func sleep() async throws {
        try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * NETWORK_SLEEP_SECS))
    }
}

struct RealLiveAppServer: LiveAppServerProtocol {
}
