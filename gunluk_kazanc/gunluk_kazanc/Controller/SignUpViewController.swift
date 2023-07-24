//
//  SignUpViewController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 9.07.2023.
//

import UIKit
import CoreData


class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var roleSegmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 22
    }


    @IBAction func signUpButtonTapped(_ sender: Any) {
        Service.shared.register(name: nameTextField.text!, email: emailTextField.text!, role: roleSegmentControl.selectedSegmentIndex + 1, password: passwordTextField.text!, onSucess: { data in
            if data.status == 422 {
                self.validateHandler(data.errors?.name?[0] ?? "", data.errors?.email?[0] ?? "", data.errors?.password?[0] ?? "")
                return
            } else if data.status == 200 {
                Service.shared.login(email: self.emailTextField.text!, password: self.passwordTextField.text!, onSucess: { data in
                    UserDefaults.standard.set(data.user.id, forKey: "UserId")
                    UserDefaults.standard.set(data.user.email, forKey: "UserEmail")
                    UserDefaults.standard.set(data.user.name, forKey: "UserName")
                    if self.roleSegmentControl.selectedSegmentIndex == 0 {
                        let vc = self.storyboard?.instantiateViewController(identifier: "CreateProfileViewController")
                        vc?.modalPresentationStyle = .fullScreen
                        self.present(vc!, animated: true)
                    } else {
                        let vc = self.storyboard?.instantiateViewController(identifier: "employerTabBar") as! CustomTabBarController
                        vc.setIndex = 0
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                }, onFail: { _ in print("Hata") })
              
            }
        }, onFail: { _ in
                let alert = UIAlertController(title: "Hata", message: "Bir Hata Oluştu", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default acction"), style: .default, handler: nil))
                self.present(alert, animated: false)
            })

    }

    private func validateHandler(_ name: String, _ email: String, _ password: String) {
        nameLabel.text = name
        emailLabel.text = email
        passwordLabel.text = password
    }


}
