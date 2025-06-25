//
//  LiveCommentView.swift
//  liveshow
//
//  Created by Liam on 2025/6/25.
//

import SwiftUI

struct LiveCommentView: View {
    @Environment(LiveAppConfigCenter.self) var configCenter: LiveAppConfigCenter
    @Environment(\.server) var server: LiveAppServerProtocol
    
    var body: some View {
        if let message = configCenter.helloMessage {
            Text(message)
                .font(.headline)
        }
    }
}
