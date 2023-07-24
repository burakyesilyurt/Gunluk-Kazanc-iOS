//
//  GunlukService.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 8.07.2023.
//

import Alamofire
import Foundation

final class Service {
    static let shared: Service = Service()
    private let baseUrl = "https://www.gunlukkazanc.net/api/"

    func fetchJobs(onSuccess: @escaping (JobsModel?) -> ()) {
        GunlukServiceManager.shared.fetch(path: GunlukPaths.jobs.rawValue) {
            (response: JobsModel) in
            onSuccess(response)
        }
    }

    func fetchProfile(profileId: Int, onSuccess: @escaping (ProfileModel?) -> ()) {
        AF.request(baseUrl + "profile/\(profileId)").responseDecodable(of: ProfileModel.self, completionHandler: {
            response in
            guard let value = response.value else {
                return }
            onSuccess(value)
        })
    }

    func login(email: String, password: String, onSucess: @escaping (LoginModel) -> Void, onFail: @escaping (String?) -> Void) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        AF.request(baseUrl + "login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: LoginModel.self, completionHandler: {
            response in
            guard let value = response.value else {
                onFail(response.debugDescription)
                return }
            onSucess(value)
        })
    }

    func register(name: String, email: String, role: Int, password: String, onSucess: @escaping (RegisterModel) -> Void, onFail: @escaping (String?) -> Void) {
        let parameters: [String: Any] = [
            "name": name,
            "email": email,
            "role": role,
            "password": password
        ]
        AF.request(baseUrl + "register", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: RegisterModel.self, completionHandler: {
            response in
            guard let value = response.value else {
                onFail(response.debugDescription)
                return }
            onSucess(value)
        })
    }

    func createProfile(name: String, age: String, phone: String, university: String?, departmant: String?, email: String, userId: Int, onSucess: @escaping (CreateProfileModel) -> Void, onFail: @escaping (String?) -> Void) {
        let parameters: [String: Any] = [
            "isim": name,
            "yas": age,
            "tel": phone,
            "universite": university,
            "bolum": departmant,
            "email": email,
            "userId": userId,
        ]

        AF.request(baseUrl + "createProfile", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: CreateProfileModel.self, completionHandler: {
            response in
            guard let value = response.value else {
                onFail(response.debugDescription)
                return }
            onSucess(value)
        })

    }

    func postJob(title: String, city: String, department: String, content: String, employerId: Int, onSuccess: @escaping (PostJobModel) -> Void) {
        let parameters: [String: Any] = [
            "baslik": title,
            "sehir": city,
            "sektor": department,
            "aciklama": content,
            "firma_id": employerId,
        ]

        AF.request(baseUrl + GunlukPaths.job.rawValue, method: .post, parameters: parameters).responseDecodable(of: PostJobModel.self, completionHandler: { response in
            guard let value = response.value else {
                return }
            onSuccess(value)
        })

    }

    func employerJobs(employerId: Int, onSucess: @escaping (EmployerJobsModel) -> Void) {
        AF.request(baseUrl + "employerWorks/\(employerId)").responseDecodable(of: EmployerJobsModel.self, completionHandler: {
            response in
            guard let value = response.value else {
                return }
            onSucess(value)
        })
    }

    func deleteJob(jobId: Int, onSucess: @escaping () -> Void) {
        AF.request(baseUrl + "job/\(jobId)", method: .delete).validate().response { response in
            switch response.result {
            case .success:
                onSucess()
            case let .failure(error):
                print(error)
            }
        }
    }

    func appliers(id: Int, onSucess: @escaping (ApplierModel) -> Void) {
        AF.request(baseUrl + "appliers/\(id)").responseDecodable(of: ApplierModel.self, completionHandler: {
            response in
            guard let value = response.value else {
                return }
            onSucess(value)
        })
    }

    func applyForAJob(firmaId: Int, ilanId: Int, userId: Int, onSucess: @escaping () -> Void) {
        let parameters: [String: Any] = [
            "firmaId": firmaId,
            "ilanId": ilanId,
            "userId": userId,
        ]
        AF.request(baseUrl + "applyJob", method: .post, parameters: parameters).response {
            response in
            onSucess()
        }
    }
}

enum GunlukPaths: String {
    case jobs = "jobs"
    case job = "job"
    case login = "login"
    case register = "register"
    case appliers = "appliers"
    case employerWorks = "employerWorks"
}
