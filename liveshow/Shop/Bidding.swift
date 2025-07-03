//
//  Bidding.swift
//  liveshow
//
//  Created by Liam on 2025/7/3.
//

import SwiftUI

struct Bidding: View {
    var body: some View {
        Text("Fixed Header")
            .font(.footnote)
            .foregroundStyle(.black)
            .padding(4)
            .background(.white.opacity(0.9))
            .frame(maxWidth: 150)
    }
}

#Preview {
    Bidding()
        .preview()
}
