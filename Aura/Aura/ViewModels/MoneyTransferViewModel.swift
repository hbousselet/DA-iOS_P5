//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    @Published var recipient: String = ""
    @Published var amount: String = ""
    @Published var transfertMessage: String = ""
    
    func sendMoney() {
        let parameters = ["recipient": recipient, "amount": amount]
        // Logic to send money - for now, we're just setting a success message.
        // You can later integrate actual logic.
        if !recipient.isEmpty && !amount.isEmpty {
            ApiService.shared.request(httpMethod: "POST", route: .transfer, responseType: Transfer.self, parameters: parameters) { isWithoutError, decodedData in
                guard isWithoutError == true else {
                    self.transfertMessage = "Not found."
                    return }
                self.transfertMessage = "Successfully transferred \(self.amount) to \(self.recipient)"
            }
        } else {
            transfertMessage = "Please enter recipient and amount."
        }
    }
    
    @MainActor
    func sendMoneyAsync() async throws{
        let parameters = ["recipient": recipient, "amount": amount]
        if !recipient.isEmpty && !amount.isEmpty {
            guard let result = try? await APIServiceAsync.shared.request(endpoint: .post(parameters), route: .transfer, responseType: Transfer.self) else {
                self.transfertMessage = "Not found."
                return }
            
            switch result {
            case .success(_):
                self.transfertMessage = "Successfully transferred \(self.amount) to \(self.recipient)"
            case .failure(let error):
                print("Fail to transfer money: \(error)")
            }
        }
    }
}
