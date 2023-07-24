//
//  LoginViewController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 9.07.2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailLabel: UITextField!
    @IBOutlet private weak var passwordLabel: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 22
        loginButton.isEnabled = false
        setViews()
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        Service.shared.login(email: emailLabel.text!, password: passwordLabel.text!, onSucess: {
            data in
            UserDefaults.standard.set(data.user.id, forKey: "UserId")
            UserDefaults.standard.set(data.user.email, forKey: "UserEmail")
            UserDefaults.standard.set(data.user.name, forKey: "UserName")
            switch data.user.role {
            case 1:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "appliersTabBar") as! UITabBarController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            case 2:
                let vc = self.storyboard?.instantiateViewController(identifier: "employerTabBar") as! CustomTabBarController
                vc.setIndex = 1
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            default:
                return
            }
        }, onFail: {
                _ in
                let alert = UIAlertController(title: "Hata", message: "Email veya Şifre Hatalı", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default acction"), style: .default, handler: { _ in
                        self.emailLabel.text = ""
                        self.passwordLabel.text = ""
                    }))
                self.present(alert, animated: false)
            })
    }
    private func setViews() {
        emailLabel.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordLabel.addTarget(self, action: #selector(validateFields), for: .editingChanged)
    }

    @objc private func validateFields() {
        loginButton.isEnabled = validateEmail(enterEmail: emailLabel.text!) && passwordLabel.text != ""
    }


}

