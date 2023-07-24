//
//  AppliersTableViewCell.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 14.07.2023.
//

import UIKit

class AppliersTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
