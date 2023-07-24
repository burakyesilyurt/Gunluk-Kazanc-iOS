//
//  GunlukService.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 8.07.2023.
//

import Foundation
import Alamofire

final class GunlukServiceManager {
    private let baseUrl = "https://www.gunlukkazanc.net/api/"

    static let shared: GunlukServiceManager = GunlukServiceManager()

    func fetch<T>(path: String, onSuccess: @escaping (T) -> ()) where T: Codable {
        AF.request(baseUrl + path, encoding: JSONEncoding.default).validate().responseDecodable(of: T.self) {
            response in
            guard let model = response.value else {
                print(response.error as Any)
                return
            }
            onSuccess(model)
        }
    }
}


