//
//  JobsViewController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 11.07.2023.
//

import UIKit

class JobsViewController: UIViewController {

    @IBOutlet var jobsBackgroundView: UIView!
    @IBOutlet weak var JobsTableView: UITableView!
    var jobs: [Job]? = [Job]()
    var activityIndicator: UIActivityIndicatorView!
    var refreshController = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "İlanlar"
        initView()
        showLoadingIndicator()
        Service.shared.fetchJobs(onSuccess: { data in
            DispatchQueue.main.async {
                self.JobsTableView.backgroundView = self.jobsBackgroundView
                self.jobs = data?.jobs
                self.hideLoadingIndicator()
                self.JobsTableView.reloadData()
            }
        })

    }

    private func initView() {
        jobsBackgroundView.isHidden = true
        JobsTableView.delegate = self
        JobsTableView.dataSource = self
        refreshController.tintColor = .white
        refreshController.addTarget(self, action: #selector(reFetchData), for: UIControl.Event.valueChanged)
        JobsTableView.addSubview(refreshController)
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = view.center
        self.view.addSubview(activityIndicator)
    }

    @objc func reFetchData(send: UIRefreshControl) {

        Service.shared.fetchJobs(onSuccess: { data in
            DispatchQueue.main.async {
                self.jobs = data?.jobs
                self.hideLoadingIndicator()
                self.JobsTableView.reloadData()
                self.refreshController.endRefreshing()
            }
        })
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
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
extension JobsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.jobs?.count == 0 {
            jobsBackgroundView.isHidden = false
            return 0
        }
        self.jobsBackgroundView.isHidden = true
        return jobs!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! JobTableViewCell
        if jobs!.count > 0 {
            do {
                let jobData = jobs![indexPath.row]
                cell.cityLabel.text = jobData.sehir
                cell.contentLabel.text = jobData.aciklama
                cell.departmentLabel.text = jobData.sektor
                cell.titleLabel.text = jobData.baslik
            }
        }
        return cell
    }

}

extension JobsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = jobs![indexPath.row]
        if let vc = storyboard?.instantiateViewController(identifier: "JobViewController") as? JobViewController {
            vc.jobData = job
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
