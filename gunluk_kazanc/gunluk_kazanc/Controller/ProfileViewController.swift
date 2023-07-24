//
//  ProfileViewController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 12.07.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var mailLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var uniLabel: UILabel!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet private weak var departmentLabel: UILabel!
    var profileData: ProfileUser? = nil
    var activityIndicator: UIActivityIndicatorView!
    var userId: Int? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.isHidden = true

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        showLoadingIndicator()
        DispatchQueue.global().async {
            if self.userId == nil {
                self.userId = UserDefaults.standard.integer(forKey: "UserId")
            }
            Service.shared.fetchProfile(profileId: self.userId!, onSuccess: { response in
                if response?.status == 200 {
                    DispatchQueue.main.async {
                        self.profileData = response?.user
                        self.setLabels()
                        self.hideLoadingIndicator()
                        self.containerView.isHidden = false
                    }
                }
            })
        }
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }

    private func setLabels() {
        nameLabel.text = profileData!.isim
        ageLabel.text = String(profileData!.yas)
        mailLabel.text = profileData!.mail
        phoneLabel.text = profileData!.telefon
        uniLabel.text = profileData?.universite ?? ""
        departmentLabel.text = profileData?.bolum ?? ""
    }

    @IBAction func updateButtonTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "CreateProfileViewController") as? CreateProfileViewController {
            vc.profileUpdateData = profileData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
