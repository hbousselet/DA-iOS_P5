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
    @Published var transferMessage: String = ""
    
    func sendMoney() {
        let parameters = ["recipient": recipient, "amount": amount]
        // Logic to send money - for now, we're just setting a success message.
        // You can later integrate actual logic.
        if !recipient.isEmpty && !amount.isEmpty {
            ApiService.shared.request(httpMethod: "POST", route: .transfer, responseType: Transfer.self, parameters: parameters) { isWithoutError, decodedData in
                guard isWithoutError == true else {
                    self.transferMessage = "Not found."
                    return }
                self.transferMessage = "Successfully transferred \(self.amount) to \(self.recipient)"
            }
        } else {
            transferMessage = "Please enter recipient and amount."
        }
    }
}
