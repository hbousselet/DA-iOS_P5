//
//  AuraServiceTestCase.swift
//  AuraServiceTestCase
//
//  Created by Hugues Bousselet on 10/11/2024.
//

import XCTest
@testable import Aura

class AuraServiceTestCase: XCTestCase {
    typealias Fake = FakeResponseData
    
//    func testGetQuoteShouldPostFailedCallbackIfError() {
//        // Given
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        let quoteService = QuoteService(quoteSession: URLSessionFake(data: nil, response: nil, error: Fake.error),
//                                        imageSession: URLSessionFake(data: nil, response: nil, error: nil))
//        //When
//        quoteService.getQuote { (success, quote) in
//            //Then
//            XCTAssertFalse(success)
//            XCTAssertNil(quote)
//            expectation.fulfill()
//        }
//        
//       
//    }
    //tests pour auth =>
//    NOK =>> wrong route? response 500, wrong http method ?
    
    func testAuthOK() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.tokenOK, response: Fake.responseOK, error: nil))
        
        //When
        auraApiService.request(httpMethod: "POST", route: .auth, responseType: Authentication.self) { (success, token) in
            //Then
            XCTAssertTrue(success)
            XCTAssertNotNil(token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAuthNOKDueToError() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.tokenOK, response: Fake.responseNOK, error: Fake.error))
        
        //When
        auraApiService.request(httpMethod: "POST", route: .auth, responseType: Authentication.self) { (success, token) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAuthNOKDueToResponseNOK() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.tokenOK, response: Fake.responseNOK, error: nil))
        
        //When
        auraApiService.request(httpMethod: "POST", route: .auth, responseType: Authentication.self) { (success, token) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAuthNOKDueToWrongData() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.tokenIncorrectData, response: Fake.responseOK, error: nil))
        
        //When
        auraApiService.request(httpMethod: "POST", route: .auth, responseType: Authentication.self) { (success, token) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //useless I think @valentin because we are only faking the return of the http calls
    func testAuthNOKDueToWrongRoute() {
        
    }
    //useless I think @valentin
    func testAuthNOKDueToWrongHTTPMethod() {
        
    }
    
    func testAccountOK() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.accountTransactionOK, response: Fake.responseOK, error: nil))

        //When
        auraApiService.request(httpMethod: "GET", route: .account, responseType: AccountInfo.self) { (success, token) in
            //Then
            XCTAssertTrue(success)
            XCTAssertNotNil(token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAccountNOKDueToError() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.accountIncorrectData, response: Fake.responseNOK, error: Fake.error))
        
        //When
        auraApiService.request(httpMethod: "GET", route: .account, responseType: AccountInfo.self) { (success, token) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAccountNOKDueToResponseNOK() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.accountTransactionOK, response: Fake.responseNOK, error: nil))
        
        //When
        auraApiService.request(httpMethod: "GET", route: .account, responseType: AccountInfo.self) { (success, token) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAccountNOKDueToWrongData() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.accountIncorrectData, response: Fake.responseOK, error: nil))
        
        //When
        auraApiService.request(httpMethod: "GET", route: .account, responseType: AccountInfo.self) { (success, token) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //Transfert
    func testTransfertOK() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.transfertOk, response: Fake.responseOK, error: nil))

        //When
        auraApiService.request(httpMethod: "GET", route: .transfer, responseType: Transfer.self) { (success, value) in
            //Then
            XCTAssertTrue(success)
            XCTAssertNil(value)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTransfertNOKDueToError() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.transfertNOK, response: Fake.responseNOK, error: Fake.error))
        
        //When
        auraApiService.request(httpMethod: "POST", route: .transfer, responseType: Transfer.self) { (success, value) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(value)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTransfertNOKDueToResponseNOK() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.transfertNOK, response: Fake.responseNOK, error: nil))
        
        //When
        auraApiService.request(httpMethod: "POST", route: .transfer, responseType: Transfer.self) { (success, value) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(value)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTransfertNOKDueToWrongData() {
        //Given
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let auraApiService = ApiService(session: URLSessionFake(data: Fake.transfertNOK, response: Fake.responseOK, error: nil))
        
        //When
        auraApiService.request(httpMethod: "POST", route: .transfer, responseType: Transfer.self) { (success, value) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(value)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    
}