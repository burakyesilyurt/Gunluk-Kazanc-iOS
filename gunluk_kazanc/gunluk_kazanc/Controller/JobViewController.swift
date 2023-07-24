//
//  JobViewController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 11.07.2023.
//

import UIKit
import CoreData

class JobViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var appliersNumberLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    var employerId: Int? = nil
    var jobId: Int? = nil
    var basvuruSayisi: Int? = nil
    public var jobData: Job? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        applyButton.layer.cornerRadius = 22

        if let job = jobData {
            titleLabel.text = job.baslik
            contentLabel.text = job.aciklama
            departmentLabel.text = job.sektor
            cityLabel.text = job.sehir
            appliersNumberLabel.text = "Başvuru Sayısı \(job.basvuruSayisi)"
            basvuruSayisi = job.basvuruSayisi
            employerId = job.firmaID
            jobId = job.id
            let userId = UserDefaults.standard.integer(forKey: "UserId")
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<AppliedJob>(entityName: "AppliedJob")
            
            let predicate = NSPredicate(format: "id == %d AND job_id == %d", userId, jobId!)
            fetchRequest.predicate = predicate
            
            do{
                let result = try context.fetch(fetchRequest)
                if !result.isEmpty{
                    self.appliersNumberLabel.text = "Başvuru Sayısı \(self.basvuruSayisi! + 1)"
                    applyButton.isEnabled = false
                }
            }catch{
                print("Hata")
            }
        }
    }

    @IBAction func applyButtonTapped(_ sender: Any) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        Service.shared.applyForAJob(firmaId: employerId!, ilanId: jobId!, userId: userId, onSucess: {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newUser = AppliedJob(context: context)
            newUser.id = Int32(userId)
            newUser.job_id = Int32(self.jobId!)
            do{
                try context.save()
            }catch{
                print("Hata")
            }
            self.appliersNumberLabel.text = "Başvuru Sayısı \(self.basvuruSayisi! + 1)"
            let alert = UIAlertController(title: "İlana Başvuruldu", message: "İlana Başvuruldu", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Tamam", comment: "Default acction"), style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
            self.present(alert, animated: false)
        })
    }
    
}
