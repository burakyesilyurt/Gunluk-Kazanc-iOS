//
//  JobPostViewController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 13.07.2023.
//

import UIKit
import Alamofire

class JobPostViewController: UIViewController {

    typealias FetchDataType = [String: String]
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var postJobButton: UIButton!
    var departmentData = [String]()
    var cityData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        postJobButton.layer.cornerRadius = 22
        contentTextView.delegate = self
        contentTextView.text = "İş Açıklaması"
        contentTextView.textColor = UIColor.lightGray
        picker(cityTextField, 1)
        picker(departmentTextField, 2)

    }

    override func viewDidAppear(_ animated: Bool) {
        fetchData("https://gist.githubusercontent.com/burakyesilyurt/9e6779acc65cda45f8a8fa9f26b3ab3d/raw/464c8463134c7d4405edca8704bc7c55e9a98e07/%25C4%25B0ller.json", completion: { data, error in
            if let data = data {
                self.cityData = data
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

    @IBAction func postJobButtonTouched(_ sender: Any) {
        let employerId = UserDefaults.standard.integer(forKey: "UserId")
        Service.shared.postJob(title: titleTextField.text!, city: cityTextField.text!, department: departmentTextField.text!, content: contentTextView.text!, employerId: employerId, onSuccess: {
            response in
            if response.status != 200{
                let alert = UIAlertController(title: "Hata", message: "Alanları Doldurun Lüften", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default acction"), style: .default, handler: nil))
                self.present(alert, animated: false)
            }
            self.tabBarController?.selectedIndex = 1
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

extension JobPostViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - UIPickerView Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return cityData.count
        } else {
            return departmentData.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            let code = cityData[row]
            return "\(code)"
        } else {
            return "\(departmentData[row])"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            let code = cityData[row]
            cityTextField.text = "\(code)"
        } else {
            departmentTextField.text = departmentData[row]
            departmentTextField.resignFirstResponder()
        }
    }
}

extension JobPostViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if contentTextView.textColor == UIColor.lightGray {
            contentTextView.text = ""
            contentTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {

        if contentTextView.text == "" {

            contentTextView.text = "Placeholder text ..."
            contentTextView.textColor = UIColor.lightGray
        }
    }
}
