//
//  UserManager.swift
//  liveshow
//
//  Created by Liam on 2025/7/4.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    var me: User {
        User(userId: 100, userName: "Liam")
    }
}
