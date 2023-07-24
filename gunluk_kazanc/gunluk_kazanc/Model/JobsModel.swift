// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginModel = try? JSONDecoder().decode(LoginModel.self, from: jsonData)

import Foundation

// MARK: - LoginModel
struct JobsModel: Codable {
    let status: Int?
    let jobs: [Job]?
}

// MARK: - Job
struct Job: Codable {
    let id, firmaID: Int
    let baslik, sehir, sektor, aciklama: String?
    let basvuruSayisi: Int
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firmaID = "firma_id"
        case baslik, sehir, sektor, aciklama
        case basvuruSayisi = "basvuru_sayisi"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// MARK: - PostJobModel
struct PostJobModel: Codable {
    let status: Int?
    let message: String?
    let errors: Errors?
    struct Errors: Codable {
        let baslik, sehir, sektor, aciklama: [String]?
    }
}

// MARK: - EmployerJobsModel
struct EmployerJobsModel: Codable {
    let status: Int?
    let works: [Work]?
}

// MARK: - Work
struct Work: Codable {
    let id, firmaID: Int?
    let baslik, sehir, sektor, aciklama: String?
    let basvuruSayisi: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firmaID = "firma_id"
        case baslik, sehir, sektor, aciklama
        case basvuruSayisi = "basvuru_sayisi"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


