//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    var token = ""
    
    let onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> ()) {
        self.onLoginSucceed = callback
    }
    
    func login() {
        ApiService.shared.httpCall(httpMethod: "POST", route: .auth, parameters: (username, password)) { isWithoutError, data in
            guard let data, isWithoutError == true else { return }
            guard let responseJson = try? JSONDecoder().decode(Authentication.self, from: data) else {
                print("not able to convert")
                return }
            self.token = responseJson.token
            self.onLoginSucceed()
            print("login with \(self.username) and \(self.password)")
        }
    }
}
