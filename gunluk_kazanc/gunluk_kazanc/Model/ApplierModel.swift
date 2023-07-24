//
//  ApplierModel.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 14.07.2023.
//

import Foundation

// MARK: - ApplierModel
struct ApplierModel: Codable {
    let status: Int?
    let appliers: [Applier]?
}

// MARK: - Applier
struct Applier: Codable {
    let id: Int?
    let name, email, baslik: String?
}
