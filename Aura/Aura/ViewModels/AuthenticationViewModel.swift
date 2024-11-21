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
        let parameters = ["username": username, "password": password]
        ApiService.shared.request(httpMethod: "POST", route: .auth, responseType: Authentication.self, parameters: parameters) { isWithoutError, decodedData in
            guard let decodedData, isWithoutError == true else { return }
            self.token = decodedData.token
            ApiService.token = decodedData.token
            self.onLoginSucceed()
            print("login with \(self.username) and \(self.password)")
        }
    }
    @MainActor
    func loginAsync() async throws {
        let parameters = ["password": password, "username": username]
        guard let result = try? await APIServiceAsync.shared.request(endpoint: .post(parameters), route: .auth, responseType: Authentication.self) else {
            return
        }
        switch result {
        case .success(let authResult):
            if let authResult {
                self.token = authResult.token
                APIServiceAsync.token = authResult.token
                self.onLoginSucceed()
                print("login with \(self.username) and \(self.password)")
            }
        case .failure(let error):
            print("Failure to log in: \(error)")
        }
    }
}
