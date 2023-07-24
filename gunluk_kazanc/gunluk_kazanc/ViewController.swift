//
//  ViewController.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 8.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 22
       
    }


}

/*
 let ser = Service()
ser.login(email: "burak@mail.com", password: "1234567", onSucess: {
    data in
    print(data)
},onFail: {
    data in
    print("h")
})
*/
