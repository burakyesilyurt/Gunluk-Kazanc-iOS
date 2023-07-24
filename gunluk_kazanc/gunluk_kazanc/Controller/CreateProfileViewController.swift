//
//  CreateProfileViewController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 10.07.2023.
//

import UIKit
import Alamofire


class CreateProfileViewController: UIViewController {
    typealias FetchDataType = [String: String]
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var ageTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var universityTextField: UITextField!
    @IBOutlet private weak var departmentTextField: UITextField!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var universityData = [String]()
    var departmentData = [String]()
    var profileUpdateData: ProfileUser? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 22
        picker(universityTextField, 1)
        picker(departmentTextField, 2)

        if profileUpdateData != nil {
            nameTextField.text = profileUpdateData!.isim
            ageTextField.text = String(profileUpdateData!.yas)
            phoneTextField.text = profileUpdateData?.telefon
            universityTextField.text = profileUpdateData?.universite ?? ""
            departmentTextField.text = profileUpdateData?.bolum ?? ""
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchData("https://gist.githubusercontent.com/burakyesilyurt/2bdf54f8592acb183d4f4dea94179ecc/raw/379bc5f38d1faae37cb4ea7c4b6f7f64534b5a09/Universiteler.json", completion: { data, error in
            if let data = data {
                self.universityData = data
            } else if let error = error {
                print(error)
            }
        })

        fetchData("https://gist.githubusercontent.com/burakyesilyurt/a2213941eb72eeef157c4f1db2e7587d/raw/4c004254e0a26178d9d9db0b19e6dc37fc26554d/sektorler.json", completion: { data, error in
            if let data = data {
                self.departmentData = data
            } else if let error = error {
                print(error)
            }
        })
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        let email = UserDefaults.standard.string(forKey: "UserEmail")
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        Service.shared.createProfile(name: nameTextField.text!, age: ageTextField.text!, phone: phoneTextField.text!, university: universityTextField.text, departmant: departmentTextField.text, email: email!, userId: userId, onSucess: {
            response in
            if response.status == 200 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "appliersTabBar") as! UITabBarController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }, onFail: {
                _ in
                let alert = UIAlertController(title: "Hata", message: "Alanları Doldurun Lüften", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default acction"), style: .default, handler: nil))
                self.present(alert, animated: false)
            })
    }

    func picker(_ textField: UITextField, _ tag: Int) {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = tag
        textField.inputView = picker
        picker.selectRow(0, inComponent: 0, animated: true)
    }


    func fetchData(_ url: String, completion: @escaping ([String]?, Error?) -> Void) {
        AF.request(url).responseDecodable(of: FetchDataType.self) { response in
            switch response.result {
            case .success(let data):
                let sortedValues = Array(data.values.sorted())
                completion(sortedValues, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

extension CreateProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - UIPickerView Delegate Methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return universityData.count
        } else {
            return departmentData.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            let code = universityData[row]
            return "\(code)"
        } else {
            return "\(departmentData[row])"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            let code = universityData[row]
            universityTextField.text = "\(code)"
        } else {
            departmentTextField.text = departmentData[row]
            departmentTextField.resignFirstResponder()
        }
    }
}
