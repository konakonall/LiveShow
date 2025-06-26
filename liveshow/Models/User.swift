//
//  User.swift
//  liveshow
//
//  Created by Liam on 2025/6/25.
//

import Foundation

struct User {
    let userId: UInt64
    let userName: String
    let userAvatar: String?
    
    init(userId: UInt64, userName: String) {
        self.userId = userId
        self.userName = userName
        self.userAvatar = nil
    }
}
