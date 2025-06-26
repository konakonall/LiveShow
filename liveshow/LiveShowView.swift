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

extension View {
    func preview() -> some View {
        self
            .environment(LiveServiceLocator())
            .preferredColorScheme(.dark)
    }
}

struct LiveShowView: View {
    @Environment(LiveServiceLocator.self) private var service: LiveServiceLocator
    
    let feedId: FeedID
    
    @State private var feed: LiveFeed?
    @State var loadingState: LoadingState = .LOADING
    
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
                    let feed = try await service.server.fetchFeedInfo(feedId: feedId)
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
        ZStack {
            PlayerView()
            VStack {
                NavigationView(feed: feed)
                Spacer()
                HStack {
                    CommentsListView(feed: feed)
                    Spacer()
                }
                CommentsView(feed: feed)
            }
            .padding(.horizontal, 8)
            .safeAreaPadding(.bottom)
        }
    }
}

#Preview {
    LiveShowView(feedId: 1, loadingState: .SUCCESS(LiveFeed.mock()))
        .preview()
}
