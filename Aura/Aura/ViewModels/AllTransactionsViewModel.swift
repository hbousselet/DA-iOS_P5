//
//  AllTransactionsViewModel.swift
//  Aura
//
//  Created by Hugues Bousselet on 08/11/2024.
//

import Foundation


class TransactionsViewModel: ObservableObject {
    var allTransactions: [AccountInfo.Transaction]
    
    @Published var model: [Transaction]?
    
    init(allTransactions: [AccountInfo.Transaction]) {
        self.allTransactions = allTransactions
        self.model = createTransactionObject(transactions: allTransactions)
    }
        
    private func createTransactionObject(transactions: [AccountInfo.Transaction]) -> [Transaction] {
        var businessTransaction = [Transaction]()
        var transactionId: Int = 1
        for transaction in transactions {
            businessTransaction.append(Transaction(description: transaction.label, amount: transaction.value.currencyString(), id: transactionId))
            transactionId += 1
        }
        return businessTransaction
    }
    
    struct Transaction: Identifiable {
        let description: String
        let amount: String
        
        var id: Int
    }
}
