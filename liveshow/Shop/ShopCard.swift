//
//  ShopCard.swift
//  liveshow
//
//  Created by Liam on 2025/7/3.
//

import SwiftUI

struct ShopCard: View {
    private let shopInfo: LiveShopInfo
    
    init(shopInfo: LiveShopInfo) {
        self.shopInfo = shopInfo
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "sun.dust")
                .font(.largeTitle)
                .frame(width: 100, height: 100)
                .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.black.opacity(0.5)))
                .padding(.vertical, 8)
            VStack(alignment: .leading) {
                Text(shopInfo.itemName)
                    .colorInvert()
                    .font(.headline)
                    .padding(.top, 10)
                Text("$\(shopInfo.price)")
                    .colorInvert()
                    .font(.footnote)
                Spacer()
                Button("Buy It Now") {
                    
                }
                .foregroundStyle(.white)
                .font(.subheadline.bold())
                .padding(4)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20).foregroundStyle(.blue))
                .padding(.bottom, 4)
            }
        }
        .padding(.horizontal, 10)
        .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.white))
        .frame(height: 108)
    }
}

#Preview {
    ShopCard(shopInfo: LiveShopInfo.mock(feedId: 1))
        .preview()
}
