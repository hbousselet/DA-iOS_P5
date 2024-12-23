//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AccountDetailViewModel: ObservableObject {
    @Published var totalAmount: Double = 0.0
    @Published var allTransactions: [Transaction] = []
    @Published var allTransactionsFromAccount: [AccountInfo.Transaction] = []
    @Published var recentTransactions: [Transaction] = []
    
    func callForLastTransactions() {
        allTransactions = []
        recentTransactions = []
        ApiService.shared.request(httpMethod: "GET", route: Route.account, responseType: AccountInfo.self) { isWithoutError, decodedData in
            guard let decodedData, isWithoutError == true else { return }
            
            self.totalAmount = decodedData.currentBalance
            //turn AccountInfo.Transaction into AccountDetailViewModel
            for transact in decodedData.transactions {
                self.allTransactions.append(Transaction(description: transact.label, amount: transact.value.currencyString()))
            }
            self.recentTransactions = Array(self.allTransactions.prefix(3))
            ApiService.allAccountTransactions = decodedData.transactions
        }
    }
    
    @MainActor
    func callForTransactionsAsync() async throws {
        allTransactions = []
        recentTransactions = []
        guard let result = try? await APIServiceAsync.shared.request(endpoint: Endpoint.get,
                                                                      route: .account,
                                                                      responseType: AccountInfo.self)
        else {
            return
        }
        
        switch result {
        case .success(let accountDetails):
            if let accountDetails {
                self.totalAmount = accountDetails.currentBalance
                self.allTransactionsFromAccount = accountDetails.transactions
                //turn AccountInfo.Transaction into AccountDetailViewModel
                for transact in accountDetails.transactions {
                    self.allTransactions.append(Transaction(description: transact.label, amount: transact.value.currencyString()))
                }
                self.recentTransactions = Array(self.allTransactions.prefix(3))
            }
        case .failure(let error):
            print("Failure to get the account details: \(error)")
        }
    }
    
    struct Transaction {
        let description: String
        let amount: String
    }
}

extension Double {
    func currencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if let result = formatter.string(from: NSNumber(value: self)) {
            // Ajouter le signe + si le montant est positif
            return self >= 0 ? "+" + result : result
        } else {
            return ""
        }
    }
}

