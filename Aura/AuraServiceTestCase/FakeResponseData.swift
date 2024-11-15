//
//  FakeResponseData.swift
//  AuraServiceTestCase
//
//  Created by Hugues Bousselet on 10/11/2024.
//

import Foundation


class FakeResponseData {
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: [:])
    
    static let responseNOK = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: [:])
    
    class AuraError: Error { }
    
    static let error = AuraError()
    
    
    //Token from auth
    static var tokenOK: Data {
        let bundle = Bundle(for: AuraServiceTestCase.self)
        let url = bundle.url(forResource: "AuthToken", withExtension: "json")!
        
        return try! Data(contentsOf: url)
    }
    
    static let tokenIncorrectData = "erreur".data(using: .utf8)!
    
    //fake token
    static let randomToken = UUID()

    //Transactions from account
    static var accountTransactionOK: Data {
        let bundle = Bundle(for: AuraServiceTestCase.self)
        let url = bundle.url(forResource: "AccountTransaction", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static let accountIncorrectData = "erreur".data(using: .utf8)!
    
    static let transfertOk = "".data(using: .utf8)
    
    static let transfertNOK = "erreur".data(using: .utf8)!

    
    //    static var quoteCorrectData: Data {
//        let bundle = Bundle(for: FakeResponseData.self)
//        let url = bundle.url(forResource: "Quote", withExtension: "json")!
//        
//        return try! Data(contentsOf: url)
//    }
    
    
    
}
