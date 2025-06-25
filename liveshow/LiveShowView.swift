//
//  LiveShowView.swift
//  liveshow
//
//  Created by Liam on 2025/6/17.
//

import SwiftUI

enum LoadingState {
    case LOADING
    case SUCCESS(LiveFeed)
    case FAILURE(Error)
}

struct LiveShowView: View {
    @Environment(LiveAppConfigCenter.self) private var configCenter: LiveAppConfigCenter
    @Environment(\.server) private var server: LiveAppServerProtocol
    
    let feedId: FeedID
    
    @State private var feed: LiveFeed?
    @State private var loadingState: LoadingState = .LOADING
    
    var body: some View {
        Group {
            switch loadingState {
            case .LOADING:
                loadingView()
            case let .SUCCESS(feed):
                feedContentView(feed: feed)
            case let .FAILURE(error):
                errorView(error: error)
            }
        }
    }
}

extension LiveShowView {
    func loadingView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .task {
                do {
                    let feed = try await server.fetchFeedInfo(feedId: feedId)
                    self.feed = feed
                    self.loadingState = .SUCCESS(feed)
                } catch {
                    self.loadingState = .FAILURE(error)
                }
            }
    }
    
    func errorView(error: Error) -> some View {
        Text(error.localizedDescription)
            .font(.largeTitle.bold())
            .padding()
    }
    
    func feedContentView(feed: LiveFeed) -> some View {
        VStack {
            NavigationView(feed: feed)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LiveShowView(feedId: 1)
        .environment(LiveAppConfigCenter())
        .environment(\.server, MockLiveAppServer())
        .preferredColorScheme(.dark)
}
