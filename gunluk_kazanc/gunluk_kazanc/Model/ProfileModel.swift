//
//  ProfileModel.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 12.07.2023.
//

import Foundation

// MARK: - CreateProfileModel
struct CreateProfileModel: Codable {
    let status: Int?
    let errors: Errors?
    let message: String?

    struct Errors: Codable {
        let isim, yas, tel: [String]?
    }
}

// MARK: - ProfileModel
struct ProfileModel: Codable {
    let status: Int?
    let user: ProfileUser?
}
struct ProfileUser: Codable {
    let id, userID: Int
    let isim: String
    let yas: Int
    let telefon: String
    let universite: String?
    let bolum, mail, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case isim, yas, telefon, universite, bolum, mail
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


