//
//  User.swift
//  FinalComputo
//
//  Created by Marcelo Preciado Fausto on 19/05/24.
//

import Foundation

class User: ObservableObject{
    static var shared : User = User(email: "")
    @Published var update : Bool = false
    @Published var errorMessage : String = ""
    @Published var loginCorrect : Bool = false
    @Published var email     : String = ""

    init(email: String) {
        self.email = email
    }
}
