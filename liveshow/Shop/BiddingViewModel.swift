//
//  BiddingViewModel.swift
//  liveshow
//
//  Created by Liam on 2025/7/4.
//

import Foundation

enum BidState: Equatable {
    case IDLE
    case LOSING(price: Double, bidder: UInt64)
    case WINNING(price: Double, bidder: UInt64)
    case END(price: Double, winner: UInt64, isWin: Bool)
}

enum BidEvent: Equatable {
    case PriceChange(price: Double, winner: UInt64)
    case BidEnd
    case BidInvalid
}

struct BidStateMachine {
    
    var state: BidState
    
    mutating func handleEvent(event: BidEvent) -> BidState {
        switch (event, state) {
        case (.PriceChange(let price, let bidder), .LOSING), (.PriceChange(let price, let bidder), .WINNING), (.PriceChange(let price, let bidder), .IDLE):
            if bidder == UserManager.shared.me.userId {
                state = .WINNING(price: price, bidder: bidder)
            } else {
                state = .LOSING(price: price, bidder: bidder)
            }
        case (.BidEnd, .LOSING(let price, let bidder)), (.BidEnd, .WINNING(let price, let bidder)):
            state = .END(price: price, winner: bidder, isWin: bidder == UserManager.shared.me.userId)
        case (.BidInvalid, .END):
            state = .IDLE
        default:
            print("invalid event: \(event), state: \(state)")
        }
        return state
    }
}

@MainActor
@Observable class BiddingViewModel: BaseLiveViewModel {
    
    var bidState: BidState = .IDLE
    private var stateMachine = BidStateMachine(state: .IDLE)
    private let shopInfo: LiveShopInfo?
    private var currentPrice = 0.0
    
    init(feed: LiveFeed, shopInfo:LiveShopInfo?, container: DependencyContainer = DependencyContainer.shared) {
        self.shopInfo = shopInfo
        super.init(feed: feed, container: container)
    }
    
    func startBid() {
        guard bidState == .IDLE else { return }
        
        currentPrice = 0
        taskManager.run { [weak self] in
            guard let self = self else { return }
            guard let shopInfo = shopInfo else { return }
            for try await (bidder, price) in server.fetchBidPriceUpdate(itemId: shopInfo.itemId) {
                bidState = stateMachine.handleEvent(event: .PriceChange(price: price, winner: bidder))
                currentPrice = price
            }
            bidState = stateMachine.handleEvent(event: .BidEnd)
            try await Task.sleep(nanoseconds: UInt64(1_000_000_000))
            
            bidState = stateMachine.handleEvent(event: .BidInvalid)
        }
    }
    
    func joinBid() {
        taskManager.run { [weak self] in
            guard let self = self else { return }
            try await server.bidPrice(itemId: UserManager.shared.me.userId, price: currentPrice + 0.5)
        }
    }
}
