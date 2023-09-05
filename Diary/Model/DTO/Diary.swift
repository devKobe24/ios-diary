//
//  Diary.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/08/30.
//

struct Diary: Decodable, Equatable {
    let title: String
    let body: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
    
    static func ==(lhs: Diary, rhs: Diary) -> Bool {
        return lhs.title == rhs.title && lhs.body == rhs.body && lhs.createdAt == rhs.createdAt
    }
}
