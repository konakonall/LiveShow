//
//  BiddingView.swift
//  liveshow
//
//  Created by Liam on 2025/7/3.
//

import SwiftUI

struct BiddingView: View {
    
    @Environment(BiddingViewModel.self) var viewModel: BiddingViewModel
    
    var body: some View {
        Group {
            switch viewModel.bidState {
            case .IDLE:
                EmptyView()
            case .LOSING(let price, let bidder):
                Text(String(format: "Price is %.2f, bid: %llu", price, bidder))
                    .background(.red.opacity(0.9))
            case .WINNING(let price, let bidder):
                Text(String(format: "Price is %.2f, bid: %llu", price, bidder))
                    .background(.green.opacity(0.9))
            case .END( _, _, let isWin):
                Text(isWin ? "YOU ARE WIN !!" : "YOU ARE LOSE.")
                    .background(.white.opacity(0.9))
            }
        }
        .font(.footnote)
        .foregroundStyle(.black)
        .padding(4)
        .frame(maxWidth: 150)
    }
}

#Preview("Empty View") {
    let feed = LiveFeed.mock()
    BiddingView()
        .environment(BiddingViewModel(feed: feed, shopInfo: LiveShopInfo.mock(feedId: feed.feedId)))
        .preview()
}

#Preview("Losing View") {
    let feed = LiveFeed.mock()
    let vm = BiddingViewModel(feed: feed, shopInfo: LiveShopInfo.mock(feedId: feed.feedId))
    vm.bidState = .LOSING(price: 100, bidder: UInt64(1))
    return BiddingView()
        .environment(vm)
        .preview()
}

#Preview("Wining View") {
    let feed = LiveFeed.mock()
    let vm = BiddingViewModel(feed: feed, shopInfo: LiveShopInfo.mock(feedId: feed.feedId))
    vm.bidState = .WINNING(price: 100, bidder: UInt64(1))
    return BiddingView()
        .environment(vm)
        .preview()
}

#Preview("End View") {
    let feed = LiveFeed.mock()
    let vm = BiddingViewModel(feed: feed, shopInfo: LiveShopInfo.mock(feedId: feed.feedId))
    vm.bidState = .END(price: 100, winner: UInt64(1), isWin: true)
    return BiddingView()
        .environment(vm)
        .preview()
}
