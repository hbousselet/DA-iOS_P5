//
//  File.swift
//  Aura
//
//  Created by Hugues Bousselet on 06/11/2024.
//

import Foundation

class ApiService {
    var task: URLSessionDataTask?
    let apiURL = "http://127.0.0.1:8080/"
    
    static var shared = ApiService()
    
    private init() {
    }
    
    func httpCall(httpMethod: String,
                   token: String? = nil,
                   route: Route,
                   parameters: (String,String)? = nil,
                   callback: @escaping ((Bool, Data?) -> Void)) {
        
        guard let url = URL(string: apiURL + route.rawValue) else {
            print("invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue(token, forHTTPHeaderField: "token")
        
        if let parameters = parameters {
            let body = "username=\(parameters.0)&password=\(parameters.1)"
            request.httpBody = body.data(using: .utf8)
        }
        
        let session = URLSession(configuration: .default)
        task?.cancel()
        
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data, error == nil else { return callback(false, nil) }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
                callback(true, data)
            }
        }
        task?.resume()
    }
}

enum Route: String {
    case auth = "auth"
    case account = "account"
    case transfer = "account/transfer"
}

struct Authentication: Decodable {
    let token: String
}

struct AccountInfo: Decodable {
    let currentBalance: Double
    let transactions: [Transaction]
    
    struct Transaction: Decodable {
        let value: Double
        let label: String
    }
}

