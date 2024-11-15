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
    static var token: String? = nil
    static var allAccountTransactions: [AccountInfo.Transaction] = []
    
    private init() {
    }
    
    //create session as a class variable and render it private not public
    private var auraSession = URLSession(configuration: .default)
    
    //init ApiService in order to be able to fake it
    init(session: URLSession) {
        self.auraSession = session
    }
    
    // à réécrire en utilisant swift concurrency + modifier les tests
    func request<T: Decodable>(httpMethod: String,
                  token: String? = token,
                  route: Route,
                  responseType: T.Type,
                  parameters: [String:String]? = nil,
                  callback: @escaping ((Bool, T?) -> Void)) {
        
        guard let url = URL(string: apiURL + route.rawValue) else {
            print("invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue(token, forHTTPHeaderField: "token")
        
        // à fixer les params + concurrency + remove token + swift 6
        //https://developer.apple.com/videos/play/wwdc2024/10169
//        request.httpBody = switch endpoint.method {
//        case .get: nil
//        case .post: try? JSONSerialization.data(withJSONObject: endpoint.parameters, options: [])
//        }
        if let parameters = parameters {
            let body = createBody(parameters)
            request.httpBody = body.data(using: .utf8)
        }
        
        task?.cancel()
        
        task = auraSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data, error == nil else { return callback(false, nil) }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return callback(false, nil) }
                
                if !data.isEmpty {
                    do {
                        let decodedData = try JSONDecoder().decode(responseType, from: data)
                        callback(true, decodedData)
                    } catch {
                        print("Not able to decode the json")
                        callback(false, nil)
                    }
                } else {
                    //no error if we are here and response status is equal to 200
                    callback(true, nil)
                }
            }
        }
        task?.resume()
    }
    
    private func createBody(_ params: [String: String]) -> String {
        var i = 1
        var body = ""
        params.forEach { key, value in
            if i == params.count {
                body += "\(key)=\(value)"
            } else {
                body += "\(key)=\(value)&"
            }
            i += 1
        }
        return body
    }
}

class APIServiceAsync {
    let apiURL = "http://127.0.0.1:8080/"
    
    static var shared = APIServiceAsync()
    static var token: String? = nil
    
    private init() {}
    
    func request<T: Decodable>(endpoint: Endpoint,
                               route: Route,
                               responseType: T.Type) async throws -> (Int, T?)? {
        
        guard let url = URL(string: apiURL + route.rawValue) else {
            print("invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        request.setValue(APIServiceAsync.token, forHTTPHeaderField: "token")
        // à voir si on garde dans toutes les situations ?
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = endpoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIErrors.invalidResponse
        }
        
        if data.isEmpty {
            return (httpResponse.statusCode, nil)
        }
        
        guard let decodedData = try? JSONDecoder().decode(responseType, from: data) else {
            throw APIErrors.invalidDecode
        }
        return (httpResponse.statusCode, decodedData)
    }
}
enum APIErrors: Error {
    case invalidResponse
    case invalidDecode
}

enum Endpoint {
    case get
    case post([String: Any])
    
    var method: Data? {
        switch self {
        case .get:
            return nil
        case let .post(parameters):
            return try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
    }
    
    var httpMethod: String {
        switch self {
        case .get:
            return "GET"
        default:
            return "POST"
        }
    }
}

struct Body: Codable {
    let key: String
    let value: String
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

struct Transfer: Decodable {}

