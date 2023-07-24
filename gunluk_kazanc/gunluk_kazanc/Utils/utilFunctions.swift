//
//  utilFunctions.swift
//  gunluk_kazanc
//
//  Created by Burak Yeşilyurt on 10.07.2023.
//

import Foundation

func validateEmail(enterEmail:String) -> Bool{
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@",emailFormat)
    return emailPredicate.evaluate(with:enterEmail)
}
