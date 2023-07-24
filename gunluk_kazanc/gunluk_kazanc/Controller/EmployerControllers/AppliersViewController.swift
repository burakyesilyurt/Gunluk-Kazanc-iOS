//
//  AppliersViewController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 13.07.2023.
//

import UIKit

class AppliersViewController: UIViewController {


    @IBOutlet var backgroundView: UIView!
    var appliersData: [Applier] = [Applier]()

    @IBOutlet weak var appliersTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        let id = UserDefaults.standard.integer(forKey: "UserId")
        Service.shared.appliers(id: id, onSucess: {
            response in
            DispatchQueue.main.async {
                self.appliersTableView.backgroundView = self.backgroundView
                if response.status == 404 {
                    self.backgroundView.isHidden = false
                } else {
                    self.backgroundView.isHidden = true
                    self.appliersData = response.appliers!
                    self.appliersTableView.reloadData()
                }
            }
        })
    }

    private func initTableView() {
        appliersTableView.dataSource = self
        appliersTableView.delegate = self
        backgroundView.isHidden = true
    }
    @IBAction func exitButtonTapped(_ sender: Any) {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        if let vc = storyboard?.instantiateViewController(identifier: "startNav") as? UINavigationController{
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

extension AppliersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.appliersData.count == 0 {
            self.backgroundView.isHidden = false
            return 0
        }
        self.backgroundView.isHidden = true
        return self.appliersData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "appliersCell") as! AppliersTableViewCell
        let rowData = self.appliersData[indexPath.row]
        cell.emailLabel.text = rowData.email
        cell.nameLabel.text = rowData.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hi")
        let applierInfo = self.appliersData[indexPath.row]
        if let vc = storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController {
            vc.userId = applierInfo.id
            vc.navigationItem.rightBarButtonItem?.isHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "appliersCell") as! AppliersTableViewCell
        headerCell.emailLabel.text = "Email"
        headerCell.nameLabel.text = "İsim"
        return headerCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }




}
