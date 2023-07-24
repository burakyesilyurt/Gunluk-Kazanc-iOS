//
//  RegisterModel.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 10.07.2023.
//

import Foundation

struct RegisterModel: Codable {
    let status: Int?
    let message: String?
    let errors: Errors?
}

struct Errors: Codable {
    let name, email, role, password: [String]?
}

