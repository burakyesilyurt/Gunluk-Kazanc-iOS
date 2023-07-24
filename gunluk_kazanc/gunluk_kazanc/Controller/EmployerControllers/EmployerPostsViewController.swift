//
//  EmployerPostsViewController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 13.07.2023.
//

import UIKit

class EmployerPostsViewController: UIViewController {

    @IBOutlet var backgroundSecondView: UIView!
    @IBOutlet weak var EmployerJobsTableView: UITableView!
    var employerJobs: [Work]? = [Work]()
    let employerId = UserDefaults.standard.integer(forKey: "UserId")
    override func viewDidLoad() {
        super.viewDidLoad()
        EmployerJobsTableView.backgroundView = backgroundSecondView
        inintView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchJobs()
    }

    private func inintView() {
        EmployerJobsTableView.delegate = self
        EmployerJobsTableView.dataSource = self
    }

    func fetchJobs() {
        Service.shared.employerJobs(employerId: self.employerId, onSucess: { data in
            DispatchQueue.main.async {
                if data.status == 404 {
                    self.backgroundSecondView.isHidden = false
                } else {
                   
                    self.backgroundSecondView.isHidden = true
                    self.employerJobs = data.works
                    self.EmployerJobsTableView.reloadData()
                }
            }
        })
    }

}

extension EmployerPostsViewController: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.employerJobs?.count == 0 {
            self.backgroundSecondView.isHidden = false
            return 0
        }
        self.backgroundSecondView.isHidden = true
        return employerJobs!.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! JobTableViewCell
        if employerJobs!.count > 0 {
            do {
                let jobData = employerJobs![indexPath.row]
                cell.cityLabel.text = jobData.sehir
                cell.contentLabel.text = jobData.aciklama
                cell.departmentLabel.text = jobData.sektor
                cell.titleLabel.text = jobData.baslik
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            Service.shared.deleteJob(jobId: self.employerJobs![indexPath.row].id!, onSucess: {
                    self.employerJobs?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                })
        }
    }
}
