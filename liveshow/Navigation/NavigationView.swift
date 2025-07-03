//
//  NavigationView.swift
//  liveshow
//
//  Created by Liam on 2025/6/25.
//

import SwiftUI

struct NavigationView: View {
    
    @State private var viewModel: NavigationViewModel
    
    init(feed: LiveFeed) {
        self.viewModel = NavigationViewModel(feed: feed)
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.backward")
                    .padding(8)
                    .background(Circle().fill(Color.gray.opacity(0.5)))
                Label("\(viewModel.feed.watchingCount)", systemImage: "eye.fill")
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                Label("Save Seller", systemImage: viewModel.isBookmarked ? "heart.fill" : "heart")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .padding(.trailing, 28)
                    .background(Color.gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(alignment: Alignment.trailing) {
                        Image(systemName: "person.fill")
                            .padding(10)
                            .background(Circle().fill(Color.blue.opacity(0.5)))
                    }
                    .labelStyle(IconClickableLabelStyle {
                        viewModel.toggleBookmark()
                    })
            }
            HStack {
                Spacer()
                Image(systemName: "ellipsis.circle")
                    .padding(10)
                    .background(Circle().fill(Color.gray.opacity(0.5)))
            }
            HStack {
                Spacer()
                Image(systemName: "ellipsis.bubble")
                    .padding(10)
                    .background(Circle().fill(Color.gray.opacity(0.5)))
            }
        }
    }
}

struct IconClickableLabelStyle: LabelStyle {
    let iconTapHandler: () -> Void
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon.onTapGesture {
                iconTapHandler()
            }
            configuration.title
        }
    }
}

#Preview {
    NavigationView(feed: LiveFeed.mock())
        .preview()
}
