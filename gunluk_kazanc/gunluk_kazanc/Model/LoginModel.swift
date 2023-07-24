//
//  LoginModel.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 8.07.2023.
//

import Foundation
struct LoginModel: Codable {
    let status: Int
    let message: String
    let user: User
}

// MARK: - User
struct User: Codable {
    let id: Int
    let name, email: String
    let role: Int
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case role
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
