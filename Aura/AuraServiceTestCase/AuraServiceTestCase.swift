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
    
class AuraServiceAsyncTestCase: XCTestCase {
    typealias Fake = FakeResponseData
    
    func testAuthOKAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.tokenOK, response: Fake.responseOK, error: nil)
        let service = APIServiceAsync(session: session)
        
        let fakeParams = ["username": "ehe", "password": "sdf"]
        
        do {
            let receivedData = try await service.request(endpoint: .post(fakeParams), route: .auth, responseType: Authentication.self)
            let result = try receivedData.get()
            XCTAssertEqual(result?.token, "D8606CD3-5708-463E-973D-AC3617DC87F5")
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testAuthNOKDueToErrorAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.tokenOK, response: Fake.responseNOK, error: Fake.error)
        let service = APIServiceAsync(session: session)
        
        let fakeParams = ["username": "ehe", "password": "sdf"]
                
        do {
            let _ = try await service.request(endpoint: .post(fakeParams), route: .auth, responseType: Authentication.self)
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testAuthNOKDueToResponseNOKAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.tokenOK, response: Fake.responseNOK, error: nil)
        let service = APIServiceAsync(session: session)
        
        let fakeParams = ["username": "ehe", "password": "sdf"]
        
        //When
        do {
            let response = try await service.request(endpoint: .post(fakeParams), route: .auth, responseType: Authentication.self)
            switch response {
            case .success(_):
                break
            case .failure(let error):
                XCTAssertTrue(error == APIErrors.invalidResponse)
            }
        } catch { }
    
    }
    
    func testAuthNOKDueToWrongDataAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.tokenIncorrectData, response: Fake.responseOK, error: nil)
        let service = APIServiceAsync(session: session)
        
        let fakeParams = ["username": "ehe", "password": "sdf"]
        
        //When
        do {
            let response = try await service.request(endpoint: .post(fakeParams), route: .auth, responseType: Authentication.self)
            switch response {
            case .success(_):
                break
            case .failure(let error):
                XCTAssertTrue(error == APIErrors.invalidDecode)
            }
        } catch { }
    }
    
    func testAccountOKAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.accountTransactionOK, response: Fake.responseOK, error: nil)
        let service = APIServiceAsync(session: session)
                
        //When
        do {
            let receivedData = try await service.request(endpoint: .get, route: .account, responseType: AccountInfo.self)
            switch receivedData {
            case .success(let response):
                XCTAssertEqual(response?.currentBalance, 5459.32)
            case .failure(let error):
                break
            }
        } catch { }
    }
    
    func testAccountNOKDueToErrorAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.accountIncorrectData, response: Fake.responseNOK, error: Fake.error)
        let service = APIServiceAsync(session: session)
                
        //When
        do {
            let _ = try await service.request(endpoint: .get, route: .account, responseType: AccountInfo.self)
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testAccountNOKDueToResponseNOKAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.accountTransactionOK, response: Fake.responseNOK, error: nil)
        let service = APIServiceAsync(session: session)
        
        //When
        do {
            let response = try await service.request(endpoint: .get, route: .account, responseType: AccountInfo.self)
            switch response {
            case .success(_):
                break
            case .failure(let error):
                XCTAssertTrue(error == APIErrors.invalidResponse)
            }
        } catch {  }
    }
    
    func testAccountNOKDueToWrongDataAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.accountIncorrectData, response: Fake.responseOK, error: nil)
        let service = APIServiceAsync(session: session)
        
        //When
        do {
            let response = try await service.request(endpoint: .get, route: .account, responseType: AccountInfo.self)
            switch response {
            case .success(_):
                break
            case .failure(let error):
                XCTAssertTrue(error == APIErrors.invalidDecode)
            }
        } catch { }
    }
    
    //Transfert
    func testTransfertOKAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.transfertOk, response: Fake.responseOK, error: nil)
        let service = APIServiceAsync(session: session)
        
        //When
        do {
            let receivedData = try await service.request(endpoint: .get, route: .transfer, responseType: Transfer.self)
            switch receivedData {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(_):
                break
            }
        } catch {}
    }
    
    func testTransfertNOKDueToErrorAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.transfertNOK, response: Fake.responseNOK, error: Fake.error)
        let service = APIServiceAsync(session: session)
                        
        do {
            let response = try await service.request(endpoint: .get, route: .transfer, responseType: Transfer.self)
            XCTAssertNil(response)
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testTransfertNOKDueToResponseNOKAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.transfertNOK, response: Fake.responseNOK, error: nil)
        let service = APIServiceAsync(session: session)
                        
        do {
            let response = try await service.request(endpoint: .get, route: .transfer, responseType: Transfer.self)
            switch response {
            case .success(_):
                break
            case .failure(let error):
                XCTAssertTrue(error == APIErrors.invalidResponse)
            }
        } catch { }
    }
    
    func testTransfertNOKDueToWrongDataAsync() async {
        //Given
        let session = MockAsyncURLSession(data: Fake.transfertNOK, response: Fake.responseOK, error: nil)
        let service = APIServiceAsync(session: session)
                        
        do {
            let response = try await service.request(endpoint: .get, route: .transfer, responseType: Transfer.self)
            switch response {
            case .success(_):
                break
            case .failure(let error):
                XCTAssertTrue(error == APIErrors.invalidDecode)
            }
        } catch { }
    }
}
