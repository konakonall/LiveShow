//
//  LiveComment.swift
//  liveshow
//
//  Created by Liam on 2025/6/26.
//

import Foundation

struct LiveComment: Identifiable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: LiveComment, rhs: LiveComment) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UInt64
    
    let author: User
    let content: String
    
    static func mockList(len: Int) -> Array<LiveComment> {
        return (1...len).map { i in
            LiveComment(id: UInt64(i), author:User(userId: UInt64(i), userName: "00\(i)"), content: "Hello from 00\(i)")
        }
    }
    
    static func mock(idx: UInt64) -> LiveComment {
        return LiveComment(id: idx, author:User(userId: idx, userName: "00\(idx)"), content: "Hello from 00\(idx)")
    }
}
