//
//  CustomTabBarController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 15.07.2023.
//

import UIKit

class CustomTabBarController: UITabBarController {

    @IBInspectable var setIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = setIndex
    }
    


}
